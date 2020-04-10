(
	[
		
		"dataset",
		"data_key",
		
		"location_key",
		"location_type",
		"location_label",
		
		"country_code",
		"country",
		"province",
		"administrative",
		"location_lat",
		"location_long",
		"region",
		"subregion",
		
		"date",
		"day_index_0",
		"day_index_1",
		"day_index_10",
		"day_index_100",
		"day_index_1k",
		"day_index_10k",
		"day_index_peak",
		"day_index_peak_confirmed",
		"day_index_peak_deaths",
		
		"absolute_confirmed",
		"absolute_deaths",
		"absolute_recovered",
		"absolute_infected",
		
		"absolute_pop100k_confirmed",
		"absolute_pop100k_deaths",
		"absolute_pop100k_recovered",
		"absolute_pop100k_infected",
		
		"relative_confirmed",
		"relative_deaths",
		"relative_recovered",
		"relative_infected",
		
		"delta_confirmed",
		"delta_deaths",
		"delta_recovered",
		"delta_infected",
		
		"delta_pct_confirmed",
		"delta_pct_deaths",
		"delta_pct_recovered",
		"delta_pct_infected",
		
		"delta_pop100k_confirmed",
		"delta_pop100k_deaths",
		"delta_pop100k_recovered",
		"delta_pop100k_infected",
		
		"peak_pct_confirmed",
		"peak_pct_deaths",
		"peak_pct_recovered",
		"peak_pct_infected",
		
		"factbook_area",
		"factbook_population",
		"factbook_death_rate",
		"factbook_median_age"
		
	]
	| join ("\t")
	
) , (
	
	.[]
	| (
		[
			
			.dataset,
			.data_key[0:12],
			
			.location.key[0:12],
			.location.type,
			.location.label,
			.location.country_code,
			.location.country,
			.location.province,
			.location.administrative,
			.location.latlong[0],
			.location.latlong[1],
			.location.region,
			.location.subregion,
			
			.date.date,
			.date.index,
			.day_index_1,
			.day_index_10,
			.day_index_100,
			.day_index_1k,
			.day_index_10k,
			.day_index_peak,
			.day_index_peak_confirmed,
			.day_index_peak_deaths
			
		] + [
			
			.values
			| (.absolute, .absolute_pop100k, .relative, .delta, .delta_pct, .delta_pop100k, .peak_pct)
			| (.confirmed, .deaths, .recovered, .infected)
			
		] + [
			
			.factbook.area,
			.factbook.population,
			.factbook.death_rate,
			.factbook.median_age
			
		]
	)
	| map (if (. != null) then tostring else "" end)
	| join ("\t")
	
)
