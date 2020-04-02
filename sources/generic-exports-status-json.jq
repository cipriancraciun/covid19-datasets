.
| group_by ([.dataset, .location.key])
| map (
	.
	| sort_by (.date.date)
	| reverse
	| .[0]
)

| map (
	{
		dataset,
		location :
			.location
			| {
				label : .label,
				type : .type,
				country_code,
				country, province, administrative,
				latlong,
			},
		date : .date.date,
		day_index :
			{
				confirmed_1 : .day_index_1,
				confirmed_10 : .day_index_10,
				confirmed_100 : .day_index_100,
				confirmed_1k : .day_index_1k,
				confirmed_10k : .day_index_10k,
				peak : .day_index_peak,
				peak_confirmed : .day_index_peak_confirmed,
				peak_deaths : .day_index_peak_deaths,
			}
			| to_entries
			| map (select (.value != null))
			| from_entries,
		values :
			.values
			| {
				absolute,
				absolute_pop100k,
				delta,
				relative,
				peak_pct,
			},
		factbook
	}
)

| map (
	{
		key :
			.location.type
			| {
				"total-country" : "countries",
				"total-province" : "provinces",
				"total-region" : "regions",
				"total-subregion" : "subregions",
				"total-world" : "world",
				"administrative" : "administrative",
			}[.],
		value : .,
	}
	| select (.key != null)
)
| group_by (.key)
| map (
	.[0].key as $key
	| map (.value)
	| map ({
		key : .location.label,
		value : .,
	})
	| sort_by (.key)
	| from_entries
	| {
		key : $key,
		value : .,
	}
)
| sort_by (.key)
| from_entries
