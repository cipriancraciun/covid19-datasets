.
| .records
| map ([.Country_Region, .Province_State, .Lat, .Long])
| group_by ([.[0], .[1]])
| map (
	.[0]
	
	| {
		key : [.[0], .[1]] | crypto_md5,
		country : .[0],
		province : .[1],
		province_latlong : [.[2], .[3]],
	}
	
	| .province = (
		if (.country == "US") then
			.province
			| if (. != null) then
				split (", ")
			else . end
			| if ((. | length) == 2) then
				.[1] + " / " + .[0]
			else
				.[0]
			end
		else
			.province
		end)
	
	| .country_0 = (
		.country
		| ascii_downcase | gsub ("[^a-z0-9]+"; "_") | gsub ("(^_+)|(_+$)"; "")
		| . as $alias
		| $countries_by_alias[$alias]
		| if (. != null) then $countries[.] else null end
		| if (. != null) then
			.
		else
			["6148536e", $alias] | debug
			| null
		end)
	
	| .country = .country_0.name
	| .country_code = .country_0.code
	| .country_latlong = .country_0.latlong
	| .region = .country_0.region
	| .subregion = .country_0.subregion
	| del (.country_0)
	
	| .label = (
		if (.province != null) then
			.country + " / " + .province
		else
			.country
		end)
	
)
| sort_by (.label)
| map ({key : .key, value : .})
| from_entries
