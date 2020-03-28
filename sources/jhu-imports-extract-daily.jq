.
| .records

| map (
	{
		dataset : "jhu/daily",
		country_region : .country_region | (if ((. != null) and (. != "")) then . else null end),
		province_state : .province_state | (if ((. != null) and (. != "")) then . else null end),
		admin2 : .admin2 | (if ((. != null) and (. != "")) then . else null end),
		fips : .fips__normalized | (if ((. != null) and (. != "")) then . else null end),
		date : .dataset | (if ((. != null) and (. != "")) then . else null end),
		values : {
			confirmed : .confirmed | (if ((. != null) and (. != "") and (. != 0)) then . else null end),
			recovered : .recovered | (if ((. != null) and (. != "") and (. != 0)) then . else null end),
			deaths : .deaths | (if ((. != null) and (. != "") and (. != 0)) then . else null end),
		},
		latitude : (.lat // .latitude) | (if ((. != null) and (. != "") and (. != 0)) then . else null end),
		longitude : (.long // .longitude) | (if ((. != null) and (. != "") and (. != 0)) then . else null end),
	}
)

| map (
	.date = (
		.date
		| split ("-")
		| map (select (. != ""))
		| map (tonumber)
		| if (.[2] < 100) then .[2] += 2000 else . end
		| [.[2], .[0], .[1]]
		| map (tostring)
		| join ("-")
	)
)

| sort_by ([.dataset, .country_region, .province_state, .admin2, .fips, .date])
