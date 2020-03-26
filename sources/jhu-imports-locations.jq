.

| map ([
		(.country_region | if (. != "") then . else null end),
		(.province_state | if (. != "") then . else null end),
		(.admin2 | if (. != "") then . else null end),
		(.latitude | if (. != 0) then . else null end),
		(.longitude | if (. != 0) then . else null end),
		(.fips | if (. != "") then . else null end)
	])

| group_by ([.[0], .[1], .[2], .[5]])
| map (
	.[0]
	
	| (. + [[.[0], .[1], .[2], .[5]] | crypto_md5])
	
	| if (.[1] | (
			(. == "None") or
			(. == "Recovered") or
			(. == "Wuhan Evacuee") or
			false
	)) then
		.[1] = null
	else . end
	
	| if (.[2] | (
			(. == "Unassigned") or
			(. == "Unknown") or
			(. == "Out of MI") or
			(. == "Out of TN") or
			(. == "Out of UT") or
			(. == "Out-of-state") or
			false
	)) then
		.[2] = null
	else . end
	
	| if ([.[0], .[1], .[2]] | (
			(. == ["Australia", "From Diamond Princess", null]) or
			(. == ["Canada", "Diamond Princess", null]) or
			(. == ["US", "Diamond Princess", null]) or
			(. == ["Cruise Ship", "Diamond Princess", null]) or
			(. == ["Cruise Ship", "Diamond+Grand Princess", null]) or
			(. == ["Others", "Diamond Princess cruise ship", null]) or
			(. == ["Others", "Cruise Ship", null]) or
			(. == ["Diamond Princess", null, null]) or
			(. == [null, "Diamond Princess", null]) or
			(. == ["Canada", "Grand Princess", null]) or
			(. == ["US", "Grand Princess", null]) or
			(. == ["Israel", "From Diamond Princess", null]) or
			(. == ["US", "Travis, CA (From Diamond Princess)", null]) or
			(. == ["US", "Omaha, NE (From Diamond Princess)", null]) or
			(. == ["US", "Lackland, TX (From Diamond Princess)", null]) or
			(. == ["US", "Unassigned Location (From Diamond Princess)", null]) or
			(. == ["US", "Grand Princess Cruise Ship", null]) or
			false
	)) then
		["Cruise Ship", "Diamond+Grand Princess", null, null, null, null, .[6]]
	else . end
	
	| if (
			[.[0], .[1], .[2]]
			| (
				(. == ["China", "Hong Kong", null]) or
				(. == ["China", "Macau", null]) or
				false
			)
	) then
		[.[1], null, null, null, null, null, .[6]]
	else . end
	
	| {
		country : .[0],
		province : .[1],
		administrative : .[2],
		province_latlong : (if ((.[3] != null) and (.[4] != null) and (.[2] == null)) then [.[3], .[4]] else null end),
		administrative_latlong : (if ((.[3] != null) and (.[4] != null) and (.[2] != null)) then [.[3], .[4]] else null end),
		administrative_fips : .[5],
		key_original : .[6],
	}
	
	| .country_original = .country
	| .province_original = .province
	| .administrative_original = .administrative
	
	| .country_0 = (
		(.country // "")
		| ascii_downcase | gsub ("[^a-z0-9]+"; "_") | gsub ("(^_+)|(_+$)"; "")
		| . as $alias
		| $countries_by_alias[$alias]
		| . as $country_code
		| if (. != null) then $countries[.] else null end
		| if (. != null) then
			.
		else
			if ($country_code != "XX") then
				["6148536e", $alias] | debug |
				null
			else
				null
			end
		end)
	
	| .country = .country_0.name
	| .country_code = .country_0.code
	| .country_latlong = .country_0.latlong
	| .region = .country_0.region
	| .subregion = .country_0.subregion
	| del (.country_0)
	
	| .province = (
		if ((.country_code != null) and ((.country == .province) or (.country_original == .province) or (.province == null))) then
			"mainland"
		else if ((.country_code == "US") and (.administrative == null)) then
			.province
			| split (", ")
			| reverse
			| map (select (. != ""))
			| if (.[0] == "D.C.") then .[0] = "DC"
			else if (.[0] == "U.S.") then .[0] = null
			else . end end
			| map (select (. != null))
			| if ((.[0] == "United States Virgin Islands") or (.[0] == "Virgin Islands")) then .[0] = "VI"
			else . end
			| map (select (. != null))
			| join (" / ")
		else if (.country_code != null) then
			.province
		else
			null
		end end end)
	
	| . as $data
	
	| if (.country != null) then
		if ((.province == null) and (.administrative != null)) then
			["6f99bfb1", .] | debug |
			$data
		else . end
	else
		if ((.province != null) or (.administrative != null)) then
			["396e159b", .] | debug |
			$data
		else . end
	end
	| if ((.administrative == null) and (.administrative_fips != null)) then
#		["174ebe53", .] | debug |
		$data
	else . end
	
)
| unique

| group_by (.country)
| map (
	if (
			(.[0].country != null)
			and ((. | map (.province) | unique | length) == 1)
			and ((. | map (.administrative) | unique | length) == 1)
			and ((. | map (.administrative_fips) | unique | length) == 1)
	) then
		map (
			.
			| .province = null
			| .province_latlong = null
			| .administrative = null
			| .administrative_latlong = null
			| .administrative_fips = null
			| .label = .country
		)
	else . end
	| .[]
)

| map (
	if (.country != null) then
		if (.province != null) then
			if (.administrative != null) then
				.type = "administrative"
				| .latlong = (.administrative_latlong // .province_latlong // .country_latlong)
				| if (.country_code == "US") then
					.
					| .us_state = (
						.province
						| . as $alias
						| ascii_downcase | gsub ("[^a-z0-9]+"; "_") | gsub ("(^_+)|(_+$)"; "")
						| if (. != null) then $us_states_by_alias[.] else . end
						| if (. != null) then $us_states[.] else . end
						| del (.aliases)
						| if (. == null) then ["a8ee874c", $alias] | debug | null else . end
					)
					| .us_county = (
						if (.administrative_fips != null) then
							.administrative_fips
						else if (.us_state != null) then
							(.us_state.code + " / " + .administrative)
						else
							.administrative
						end end
						| ascii_downcase | gsub ("[^a-z0-9]+"; "_") | gsub ("(^_+)|(_+$)"; "")
						| . as $alias
						| if (. != null) then $us_counties_by_alias[.] else . end
						| if (. != null) then $us_counties[.] else . end
						| del (.state_name)
						| del (.state_code)
						| del (.aliases)
						| if (. == null) then ["425ac107", $alias] | debug | null else . end
					)
				else . end
			else
				.type = "province"
				| .latlong = (.province_latlong // .country_latlong)
				| if ((.country_code == "US") and (.province != "mainland")) then
					.
					| .us_state = (
						.province
						| split (" / ")
						| .[0]
						| ascii_downcase | gsub ("[^a-z0-9]+"; "_") | gsub ("(^_+)|(_+$)"; "")
						| . as $alias
						| if (. != null) then $us_states_by_alias[.] else . end
						| if (. != null) then $us_states[.] else . end
						| del (.aliases)
						| if (. == null) then ["349f7064", $alias] | debug | null else . end
					)
				else . end
			end
		else
			.type = "country"
			| .latlong = .country_latlong
		end
		| if (.us_state != null) then
			.province = .us_state.name
		else
			del (.us_state)
		end
		| if (.us_county == null) then
			.
			| .administrative = .us_county.name
			| .administrative_fips = .us_county.fips
		else
			del (.us_county)
		end
		| .label = ([.country, .province, .administrative] | map (select (. != null)) | join (" / "))
	else
		.
		| .label = ([.country_original, .province_original, .administrative_original] | map (select (. != null)) | join (" / "))
		| .type = "unknown"
		| .latlong = null
		| .province = null
		| .province_latlong = null
		| .administrative = null
		| .administrative_fips = null
		| .administrative_latlong = null
	end
)

| map (
	.key = if (.country != null) then
		([.country, .province, .administrative] | crypto_md5)
	else
		([.country_original, .province_original, .administrative_original] | crypto_md5)
	end
)

| sort_by ([.country, .location_label, .province, .administrative, .key_original])
| map ({key : .key_original, value : .})
| from_entries
