.
| .records
| map ([
		(.country_region | if (. != "") then . else null end),
		(.province_state | if (. != "") then . else null end),
		(.admin2 | if (. != "") then . else null end),
		(.lat | if (. != 0) then . else null end),
		(.long | if (. != 0) then . else null end)
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
				(. == ["Diamond Princess", null, null]) or
				(. == [null, "Diamond Princess", null]) or
				false
			)
	) then
		["Cruise Ship", "Diamond Princess", null, null, null, .[5]]
	else . end
	
	| {
		country : .[0],
		province : .[1],
		administrative : .[2],
		province_latlong : (if ((.[3] != null) and (.[4] != null)) then [.[3], .[4]] else null end),
		key_original : .[5],
	}
	
	| .country_original = .country
	| .province_original = .province
	| .administrative_original = .administrative
	
	| .province = (
		if ((.country == .province) or (.province == null)) then
			"mainland"
		else if ((.country == "US") and (.administrative == null)) then
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
	
	| .country_0 = (
		(.country // "")
		| ascii_downcase | gsub ("[^a-z0-9]+"; "_") | gsub ("(^_+)|(_+$)"; "")
		| . as $alias
		| $countries_by_alias[$alias]
		| if (. != null) then $countries[.] else null end
		| if (. != null) then
			.
		else
			["6148536e", $alias] | debug |
			null
		end)
	
	| .country = .country_0.name
	| .country_code = .country_0.code
	| .country_latlong = .country_0.latlong
	| .region = .country_0.region
	| .subregion = .country_0.subregion
	| del (.country_0)
	
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
			| .administrative = null
			| .label = .country
		)
	else . end
	| .[]
)
| map (
	.key = ([.country, .province, .administrative] | crypto_md5)
)
| map (
	if (.country != null) then
		if (.province != null) then
			if (.administrative != null) then
				.type = "administrative"
			else
				.type = "province"
			end
		else
			.type = "country"
		end
	else
		.
		| .type = "unknown"
		| .label = ([.country_original, .province_original, .administrative_original] | map (select (. != null)) | join (" / "))
		| .province = null
	end
)
| sort_by ([.country, .province, .administrative, .key_original])
| map ({key : .key_original, value : .})
| from_entries
