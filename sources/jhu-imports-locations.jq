.
| map ([
		(.country_region | if (. != "") then . else null end),
		(.province_state | if (. != "") then . else null end),
		(.admin2 | if (. != "") then . else null end),
		(.latitude | if (. != 0) then . else null end),
		(.longitude | if (. != 0) then . else null end)
	])
| group_by ([.[0], .[1], .[2]])
| map (
	.[0]
	
	| (. + [[.[0], .[1], .[2]] | crypto_md5])
	
	| if (
			[.[0], .[1], .[2]]
			| (
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
				false
			)
	) then
		["Cruise Ship", "Diamond+Grand Princess", null, null, null, .[5]]
	else . end
	
	| if (
			[.[0], .[1], .[2]]
			| (
				(. == ["China", "Hong Kong", null]) or
				(. == ["China", "Macau", null]) or
				false
			)
	) then
		[.[1], null, null, null, null, .[5]]
	else . end
	
	| {
		country : .[0],
		province : .[1],
		administrative : .[2],
		province_latlong : (if ((.[3] != null) and (.[4] != null) and (.[2] == null)) then [.[3], .[4]] else null end),
		administrative_latlong : (if ((.[3] != null) and (.[4] != null) and (.[2] != null)) then [.[3], .[4]] else null end),
		key_original : .[5],
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
			| if ((. | length) == 2) then
				.[1] + " / " + .[0]
			else
				.[0]
			end
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
	
	| .label = ([.country, .province, .administrative] | map (select (. != null)) | join (" / "))
	
)
| unique
| group_by (.country)
| map (
	if (
			(.[0].country != null)
			and ((. | map (.province) | unique | length) == 1)
			and ((. | map (.administrative) | unique | length) == 1)
	) then
		map (
			.
			| .province = null
			| .province_latlong = null
			| .administrative = null
			| .administrative_latlong = null
			| .label = .country
		)
	else . end
	| .[]
)
| map (
	.key = if (.country != null) then
		([.country, .province, .administrative] | crypto_md5)
	else
		([.country_original, .province_original, .administrative_original] | crypto_md5)
	end
)
| map (
	if (.country != null) then
		if (.province != null) then
			if (.administrative != null) then
				.type = "administrative"
				| .latlong = (.administrative_latlong // .province_latlong // .country_latlong)
			else
				.type = "province"
				| .latlong = (.province_latlong // .country_latlong)
			end
		else
			.type = "country"
			| .latlong = .country_latlong
		end
	else
		.
		| .label = ([.country_original, .province_original, .administrative_original] | map (select (. != null)) | join (" / "))
		| .type = "unknown"
		| .latlong = null
		| .province = null
		| .province_latlong = null
		| .administrative = null
		| .administrative_latlong = null
	end
)
| sort_by ([.country, .location_label, .province, .administrative, .key_original])
| map ({key : .key_original, value : .})
| from_entries
