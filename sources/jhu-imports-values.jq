.
| .records
| map (
	.location = ([.Country_Region, .Province_State] | crypto_md5 | $locations[.])
)
| map (
	. as $record
	| $dates
	| .[]
	| {
		dataset : $record.dataset,
		location : $record.location,
		date : .,
		value : $record[.key],
	}
)

| group_by ([.location.key, .date.key])
| map ({
	location : .[0].location,
	date : .[0].date | del (.key),
	values : map ({key : .dataset, value : .value}) | from_entries,
})

| (. + (
	(
		.
		+ map (
			.location.country = .location.region
			| .location.subregion = null | .location.country_code = null | .location.country_latlong = null)
		+ map (
			.location.country = .location.subregion
			| .location.subregion = null | .location.country_code = null | .location.country_latlong = null)
	)
	| group_by ([.location.country, .date])
	| map (
		{
			location : (
				.[0].location
				| .key = ([.country, "total"] | crypto_md5)
				| .province = "total"
				| .province_latlong = null
				| .label = .country
			),
			date : .[0].date,
			values :
				map (.values | to_entries | .[])
				| group_by (.key)
				| map ({
					key : .[0].key,
					value : map (.value) | add,
				})
				| from_entries
		}
	)
))

| sort_by ([.location.country, .date.date, .location.label, .location.province, .location.key])
