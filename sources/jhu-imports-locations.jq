.
| .records
| map ([
		(.Country_Region | if (. != "") then . else null end),
		(.Province_State | if (. != "") then . else null end),
		(.Lat | if (. != 0) then . else null end),
		(.Long | if (. != 0) then . else null end)
	])
| group_by ([.[0], .[1]])
| map (
	.[0]
	
	| (. + [[.[0], .[1]] | crypto_md5])
	
	| if (
			[.[0], .[1]]
			| (
				(. == ["Australia", "From Diamond Princess"]) or
				(. == ["Canada", "Diamond Princess"]) or
				(. == ["US", "Diamond Princess"]) or
				(. == ["Cruise Ship", "Diamond Princess"]) or
				false
			)
	) then
		["Cruise Ship", "Diamond Princess", null, null, .[4]]
	else . end
	
	| {
		country : .[0],
		province : .[1],
		province_latlong : (if ((.[2] != null) and (.[3] != null)) then [.[2], .[3]] else null end),
		key_original : .[4],
	}
	
	| .country_original = .country
	| .province_original = .province
	
	| .province = (
		if ((.country == .province) or (.province == null) or (.province == "")) then
			"mainland"
		else if (.country == "US") then
			.province
			| split (", ")
			| if ((. | length) == 2) then
				.[1] + " / " + .[0]
			else
				.[0]
			end
		else
			.province
		end end)
	
	| .country_0 = (
		.country
		| ascii_downcase | gsub ("[^a-z0-9]+"; "_") | gsub ("(^_+)|(_+$)"; "")
		| . as $alias
		| $countries_by_alias[$alias]
		| if (. != null) then $countries[.] else null end
		| if (. != null) then
			.
		else
			# ["6148536e", $alias] | debug |
			null
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
| unique
| group_by (.country)
| map (
	if ((. | map (.province) | unique | length) == 1) then
		map (
			.
			| .province = null
			| .label = .country
		)
	else . end
	| .[]
)
| map (
	.key = ([.country, .province] | crypto_md5)
)
| map (
	if (.country != null) then
		if (.province != null) then
			.type = "province"
		else
			.type = "country"
		end
	else
		.
		| .type = "unknown"
		| .label = ([.country_original, .province_original] | map (select (. != null)) | join (" / "))
	end
)
| sort_by ([.country, .province])
| map ({key : .key_original, value : .})
| from_entries
