.
| .records

| map (
	{
		country_region : .country_region,
		province_state : .province_state,
		admin2 : .admin2,
		fips : .fips__normalized,
		date : .dataset,
		values : {
			confirmed : .confirmed,
			recovered : .recovered,
			deaths : .deaths,
		},
		latitude : (.lat // .latitude),
		longitude : (.long // .longitude),
	}
)

| map (
	.date = (
		.date
		| split ("-")
		| map (select (. != ""))
		| map (tonumber)
		| if (.[2] < 100) then .[2] += 2000 else . end
		| map (tostring)
		| join ("-")
	)
)

| sort_by ([.country_region, .province_state, .admin2, .fips, .date])
