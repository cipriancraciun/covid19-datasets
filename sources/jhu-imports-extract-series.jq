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
		dataset : $record.dataset | (if ((. != null) and (. != "")) then . else null end),
		country_region : $record.country_region | (if ((. != null) and (. != "")) then . else null end),
		province_state : $record.province_state | (if ((. != null) and (. != "")) then . else null end),
		admin2 : $record.admin2 | (if ((. != null) and (. != "")) then . else null end),
		fips : $record.fips__normalized | (if ((. != null) and (. != "")) then . else null end),
		date : . | (if ((. != null) and (. != "")) then . else null end),
		value : $record[.] | (if ((. != null) and (. != "") and (. != 0)) then . else null end),
		latitude : ($record.lat // $record.latitude) | (if ((. != null) and (. != "") and (. != 0)) then . else null end),
		longitude : ($record.long // $record.longitude) | (if ((. != null) and (. != "") and (. != 0)) then . else null end),
	}
)

| group_by ([.country_region, .province_state, .admin2, .fips, .date])
| map ({
	dataset : "jhu/series",
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
		| [.[2], .[0], .[1]]
		| map (tostring)
		| join ("-")
	)
)

| sort_by ([.dataset, .country_region, .province_state, .admin2, .fips, .date])
