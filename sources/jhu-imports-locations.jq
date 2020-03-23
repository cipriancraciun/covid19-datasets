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
		lat_long : [.[2], .[3]],
	}
	| .province_0 = (
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
	| .label = (
		if (.province_0 != null) then
			.country + " / " + .province_0
		else
			.country
		end)
	| del (.province_0)
)
| sort_by (.label)
| map ({key : .key, value : .})
| from_entries
