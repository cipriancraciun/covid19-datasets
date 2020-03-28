.
| .records as $records
| .keys as $keys
| $records

| map (
	. as $record
	| $keys
	| to_entries
	| .[]
	| .key
	| select (. | startswith ("_"))
	| {
		dataset : $record.dataset,
		country_region : $record.country_region,
		province_state : $record.province_state,
		admin2 : $record.admin2,
		fips : $record.fips__normalized,
		date : .,
		value : $record[.],
		latitude : ($record.lat // $record.latitude),
		longitude : ($record.long // $record.longitude),
	}
)

| group_by ([.country_region, .province_state, .admin2, .fips, .date])
| map ({
	country_region : .[0].country_region,
	province_state : .[0].province_state,
	admin2 : .[0].admin2,
	fips : .[0].fips,
	date : .[0].date,
	latitude : .[0].latitude,
	longitude : .[0].longitude,
	values :
		map ({key : .dataset, value : .value})
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
		| split ("_")
		| map (select (. != ""))
		| map (tonumber)
		| if (.[2] < 100) then .[2] += 2000 else . end
		| map (tostring)
		| join ("-")
	)
)

| sort_by ([.country_region, .province_state, .admin2, .fips, .date])
