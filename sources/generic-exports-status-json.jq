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
	.location.type |= (
			{
				
				"total-country" : "country",
				"total-province" : "province",
				"total-region" : "region",
				"total-subregion" : "subregion",
				"total-world" : "world",
				"administrative" : "administrative",
			}[.]
		)
	| select (.location.type != null)
)

| group_by (.location.type)
| map (
	.[0].location.type as $type
	| map ({
		key : .location.label,
		value : .,
	})
	| sort_by (.key)
	| from_entries
	| {
		key : $type,
		value : .,
	}
)
| sort_by (.key)
| from_entries
