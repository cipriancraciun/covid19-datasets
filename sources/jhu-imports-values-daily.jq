.
| .records as $records
| .keys as $keys
| $records

| map (
	. as $record
	| {
		country_region : $record.country_region,
		province_state : $record.province_state,
		admin2 : $record.admin2,
		date : $record.dataset,
		latitude : ($record.lat // $record.latitude),
		longitude : ($record.long // $record.longitude),
		values : {
			confirmed : .confirmed,
			recovered : .recovered,
			deaths : .deaths,
		},
	}
)

| group_by ([.country_region, .province_state, .admin2, .date])
| map ({
	country_region : .[0].country_region,
	province_state : .[0].province_state,
	admin2 : .[0].admin2,
	date : .[0].date,
	latitude : .[0].latitude,
	longitude : .[0].longitude,
	values :
		map (.values | to_entries | .[])
		| group_by (.key)
		| map ({
			key : .[0].key,
			value : map (.value) | add,
		})
		| from_entries,
})

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

| sort_by ([.country_region, .province_state, .admin2, .date])
