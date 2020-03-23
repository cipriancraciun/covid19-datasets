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
| group_by ([.location.country, .date])
| map (
	{
		location : {
			key : [.[0].location.country, "total"] | crypto_md5,
			country : .[0].location.country,
			province : "total",
			label : .[0].location.country,
		},
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
	,
	.[]
)
| sort_by ([.location.country, .date.date, .location.label, .location.province, .location.key])
