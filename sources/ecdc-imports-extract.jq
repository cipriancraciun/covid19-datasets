.
| .records

| map (
	{
		dataset : ("ecdc/" + .dataset),
		country_region : .countriesandterritories | (if ((. != null) and (. != "")) then . else null end),
		province_state : null,
		admin2 : null,
		fips : null,
		date : .daterep | (if ((. != null) and (. != "")) then . else null end),
		values : {
			confirmed : .cases | (if ((. != null) and (. != "") and (. != 0)) then . else null end),
			deaths : .deaths | (if ((. != null) and (. != "") and (. != 0)) then . else null end),
		},
	}
)

| map (
	.date = (
		.date
		| split ("/")
		| map (select (. != ""))
		| map (tonumber)
		| [.[2], .[1], .[0]]
		| map (tostring)
		| join ("-")
	)
)

| sort_by ([.dataset, .country_region, .province_state, .admin2, .fips, .date])
