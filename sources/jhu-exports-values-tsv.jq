(
	[
		
		"location_key",
		"location_type",
		"location_label",
		
		"country_code",
		"country",
		"province",
		"location_lat",
		"location_long",
		
		"date",
		"day_index_1",
		"day_index_10",
		"day_index_100",
		"day_index_1k",
		"day_index_10k",
		
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
		
		"deltapct_confirmed",
		"deltapct_deaths",
		"deltapct_recovered",
		"deltapct_infected",
		
		"factbook_area",
		"factbook_population",
		"factbook_death_rate",
		"factbook_median_age",
		
		"location_key_original",
		"country_original",
		"province_original"
		
	]
	| join ("\t")
	
) , (
	
	.[]
	| .location.latlong = (.location.province_latlong // .location.country_latlong)
	| (
		[
		
			.location.key,
			.location.type,
			.location.label,
			.location.country_code,
			.location.country,
			.location.province,
			.location.latlong[0],
			.location.latlong[1],
			
			.date.date,
			.day_index_1,
			.day_index_10,
			.day_index_100,
			.day_index_1k,
			.day_index_10k
			
		] + [
			
			.values
			| (.absolute, .absolute_pop100k, .relative, .delta, .delta_pct)
			| (.confirmed, .deaths, .recovered, .infected)
			
		] + [
			
			.factbook.area,
			.factbook.population,
			.factbook.death_rate,
			.factbook.median_age,
			
			.location.key_original,
			.location.country_original,
			.location.province_original
			
		]
	)
	| map (if (. != null) then tostring else "" end)
	| join ("\t")
	
)