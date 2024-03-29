.

| map ([
		.country_region,
		.province_state,
		.admin2,
		.latitude,
		.longitude,
		.fips,
		.dataset
	])

| group_by ([.[0], .[1], .[2], .[5], .[6]])
| map (
	.[0]
	
	| (.[0:6] + [
		([.[0], .[1], .[2], .[5]] | crypto_md5),
		([.[0], .[1], .[2], .[5]]),
		.[6]
	])
	
	# NOTE:  Re-map some country names.
	| if (.[0] == "US") then
		.[0] = "United States"
	else . end
	
	# NOTE:  Drop false `administrative` values.
	| if (.[1] | (
			(. == "None") or
			(. == "Unknown") or
			(. == "Recovered") or
			(. == "Wuhan Evacuee") or
			false
	)) then
		.[1] = null
	else . end
	
	# NOTE:  Drop false `province` values.
	| if (.[2] | (
			(. == "Unassigned") or (. == "unassigned") or
			(. == "Unknown") or (. == "unknown") or
			(. == "Out of MI") or
			(. == "Out of TN") or
			(. == "Out of UT") or
			(. == "Out of OK") or
			(. == "Out of CO") or
			(. == "Out of HI") or
			(. == "Out of GA") or
			(. == "Out of IL") or
			(. == "Out of AL") or
			(. == "Out of LA") or
			(. == "Out of PR") or
			(. == "Out of AZ") or
			(. == "Out of KS") or
			(. == "Out of ME") or
			(. == "Out of NY") or
			(. == "Out-of-state") or
			# NOTE:  Administrative in Utah
			(. == "Bear River") or
			(. == "Central Utah") or
			(. == "Southeast Utah") or
			(. == "Southwest Utah") or
			(. == "TriCounty") or
			# NOTE:  Administrative in Michigan
			(. == "Federal Correctional Institution (FCI)") or
			(. == "Michigan Department of Corrections (MDOC)") or
			false
	)) then
		.[2] = null
	else . end
	
	# NOTE:  Merge cruise ships and olympics under one item.
	| if ([.[0], .[1], .[2]] | (
			(. == ["Australia", "From Diamond Princess", null]) or
			(. == ["Canada", "Diamond Princess", null]) or
			(. == ["United States", "Diamond Princess", null]) or
			(. == ["Cruise Ship", "Diamond Princess", null]) or
			(. == ["Cruise Ship", "Diamond+Grand Princess", null]) or
			(. == ["Others", "Diamond Princess cruise ship", null]) or
			(. == ["Others", "Cruise Ship", null]) or
			(. == ["Diamond Princess", null, null]) or
			(. == [null, "Diamond Princess", null]) or
			(. == ["Canada", "Grand Princess", null]) or
			(. == ["United States", "Grand Princess", null]) or
			(. == ["Israel", "From Diamond Princess", null]) or
			(. == ["United States", "Travis, CA (From Diamond Princess)", null]) or
			(. == ["United States", "Omaha, NE (From Diamond Princess)", null]) or
			(. == ["United States", "Lackland, TX (From Diamond Princess)", null]) or
			(. == ["United States", "Unassigned Location (From Diamond Princess)", null]) or
			(. == ["United States", "Grand Princess Cruise Ship", null]) or
			(. == ["MS Zaandam", null, null]) or
			(. == ["Summer Olympics 2020", null, null]) or
			(. == ["Winter Olympics 2022", null, null]) or
			false
	)) then
		["Miscellaneous", null, null, null, null, null, .[6], .[7], .[8]]
	else . end
	
	# NOTE:  Drop US counties for states that are next mapped as countries.
	| if ([.[0], .[1]] | (
			(. == ["United States", "Puerto Rico"]) or
			(. == ["United States", "Northern Mariana Islands"]) or
			(. == ["United States", "Virgin Islands"]) or
			false
	)) then
		[.[0], .[1], null, null, null, null, .[6], .[7], .[8]]
	else . end
	
	# NOTE:  Re-map some provinces an countries.
	| if (
			[.[0], .[1], .[2]]
			| (
				(. == ["China", "Hong Kong", null]) or
				(. == ["China", "Macau", null]) or
				(. == ["Netherlands", "Aruba", null]) or
				(. == ["Netherlands", "Curacao", null]) or
				(. == ["Netherlands", "Sint Maarten", null]) or
				(. == ["Netherlands", "Bonaire, Sint Eustatius and Saba", null]) or
				(. == ["Denmark", "Faroe Islands", null]) or
				(. == ["Denmark", "Greenland", null]) or
				(. == ["France", "Saint Barthelemy", null]) or
				(. == ["France", "Fench Guiana", null]) or
				(. == ["France", "French Guiana", null]) or
				(. == ["France", "French Polynesia", null]) or
				(. == ["France", "Guadeloupe", null]) or
				(. == ["France", "Martinique", null]) or
				(. == ["France", "Mayotte", null]) or
				(. == ["France", "New Caledonia", null]) or
				(. == ["France", "Reunion", null]) or
				(. == ["France", "St Martin", null]) or
				(. == ["France", "Saint Pierre and Miquelon", null]) or
				(. == ["France", "Wallis and Futuna", null]) or
				(. == ["Belgium", "Luxembourg", null]) or
				(. == ["New Zealand", "Cook Islands", null]) or
				(. == ["United Kingdom", "Anguilla", null]) or
				(. == ["United Kingdom", "Bermuda", null]) or
				(. == ["United Kingdom", "British Virgin Islands", null]) or
				(. == ["United Kingdom", "Cayman Islands", null]) or
				(. == ["United Kingdom", "Gibraltar", null]) or
				(. == ["United Kingdom", "Isle of Man", null]) or
				(. == ["United Kingdom", "Montserrat", null]) or
				(. == ["United Kingdom", "Turks and Caicos Islands", null]) or
				(. == ["United Kingdom", "Guernsey", null]) or
				(. == ["United Kingdom", "Falkland Islands (Malvinas)", null]) or
				(. == ["United Kingdom", "Saint Helena, Ascension and Tristan da Cunha", null]) or
				(. == ["United Kingdom", "Jersey", null]) or
				(. == ["United States", "United States Virgin Islands", null]) or
				(. == ["United States", "Virgin Islands", null]) or
				(. == ["United States", "Virgin Islands, U.S.", null]) or
				(. == ["United States", "Puerto Rico", null]) or
				(. == ["United States", "American Samoa", null]) or
				(. == ["United States", "Guam", null]) or
				(. == ["United States", "Northern Mariana Islands", null]) or
				false
			)
	) then
		[.[1], null, null, null, null, null, .[6], .[7], .[8]]
	else . end
	
	# NOTE:  Drop some "singleton" provinces.
	| if (
			[.[0], .[1], .[2]]
			| (
				(. == ["Germany", "Bavaria", null]) or
				(. == ["United States", "US", null]) or
				(. == ["United States", "US Military", null]) or
				(. == ["United States", "US Military", "Unassigned"]) or
				(. == ["United States", "US Military", "Air Force"]) or
				(. == ["United States", "US Military", "Army"]) or
				(. == ["United States", "US Military", "Marine Corps"]) or
				(. == ["United States", "US Military", "Navy"]) or
				(. == ["United States", "US Military", "Unassigned"]) or
				(. == ["United States", "Federal Bureau of Prisons", "Inmates"]) or
				(. == ["United States", "Federal Bureau of Prisons", "Staff"]) or
				(. == ["United States", "Veteran Hospitals", null]) or
				false
			)
	) then
		[.[0], null, null, null, null, null, .[6], .[7], .[8]]
	else . end
	
	# NOTE:  Re-group some US counties.
	| if (
			[.[0], .[1], .[2]]
			| (
				(. == ["United States", "Utah", "Southwest"]) or
				false
			)
	) then
		[.[0], .[1], null, null, null, null, .[6], .[7], .[8]]
	else . end
	
	# NOTE:  Re-group some teritories under UK.
	| if (
			[.[0], .[1], .[2]]
			| (
				(. == ["United Kingdom", "UK", null]) or
				(. == ["United Kingdom", "Channel Islands", null]) or
				(. == ["Channel Islands", null, null]) or
				false
			)
	) then
		["United Kingdom", null, null, null, null, null, .[6], .[7], .[8]]
	else . end
	
	| {
		dataset : .[8],
		country : .[0],
		province : .[1],
		administrative : .[2],
		province_latlong : (if ((.[3] != null) and (.[4] != null) and (.[2] == null)) then [.[3], .[4]] else null end),
		administrative_latlong : (if ((.[3] != null) and (.[4] != null) and (.[2] != null)) then [.[3], .[4]] else null end),
		administrative_fips : .[5],
		key_original : .[6],
		country_original : .[0],
		province_original : .[1],
		administrative_original : .[2],
		country_original_0 : .[7][0],
		province_original_0 : .[7][1],
		administrative_original_0 : .[7][2],
	}
	
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
			"(mainland)"
		else
			if ((.province != null) and (.province != "Georgia") and ($countries_by_alias[.province] != null)) then
				. as $data
				| ["12c87205", $data.country, $data.province, $countries_by_alias[.province]] | debug |
				$data
			else . end
			| if ((.country_code == "US") and (.administrative == null)) then
				.province
				| split (", ")
				| reverse
				| map (select (. != ""))
				| .[0] |= (
					{
						"D.C." : "DC",
					}[.] // .
				)
				| map (select (. != null))
				| join (" / ")
			else if (.country_code != null) then
				.province
			else
				null
			end end
		end)
	
	
	
	| if (.country != null) then
		if ((.province == null) and (.administrative != null)) then
			. as $data
			| ["6f99bfb1", .] | debug
			| $data
		else . end
	else
		if ((.province != null) or (.administrative != null)) then
			. as $data
			| ["396e159b", .] | debug
			| $data
		else . end
	end
	| if ((.administrative == null) and (.administrative_fips != null)) then
		. as $data
#		| ["174ebe53", .] | debug
		| $data
		| .administrative_fips = null
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
						| del (.name_normalized)
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
						| del (.name_normalized)
						| del (.state_name)
						| del (.state_code)
						| del (.aliases)
						| if (. == null) then ["425ac107", $alias] | debug | null else . end
					)
				else . end
			else
				.type = "province"
				| .latlong = (.province_latlong // .country_latlong)
				| if ((.country_code == "US") and (.province != "(mainland)")) then
					.
					| .us_state = (
						.province
						| split (" / ")
						| .[0]
						| ascii_downcase | gsub ("[^a-z0-9]+"; "_") | gsub ("(^_+)|(_+$)"; "")
						| . as $alias
						| if (. != null) then $us_states_by_alias[.] else . end
						| if (. != null) then $us_states[.] else . end
						| del (.name_normalized)
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
		| if (.us_county != null) then
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

| map (
	.
	| .country_original = .country_original_0
	| .province_original = .province_original_0
	| .administrative_original = .administrative_original_0
	| del (.country_original_0)
	| del (.province_original_0)
	| del (.administrative_original_0)
)

| sort_by ([.country, .location_label, .province, .administrative, .key_original])
| map ({key : .key_original, value : .})
| from_entries
