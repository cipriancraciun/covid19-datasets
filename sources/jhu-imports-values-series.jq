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
		date : .,
		value : $record[.],
	}
)

| group_by ([.country_region, .province_state, .admin2, .date])
| map ({
	country_region : .[0].country_region,
	province_state : .[0].province_state,
	admin2 : .[0].admin2,
	date : .[0].date,
	values :
		map ({key : .dataset, value : .value})
		| group_by (.key)
		| map ({
			key : .[0].key,
			value : map (.value) | add,
		})
		| from_entries,
})

| sort_by ([.country_region, .province_state, .admin2, .date])
