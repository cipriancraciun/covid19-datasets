map (
	{
		
		dataset : .dataset,
		data_key : .data_key,
		
		location_key : .location.key,
		location_type : .location.type,
		location_label : .location.label,
		
		country_code : .location.country_code,
		country : .location.country,
		province : .location.province,
		administrative : .location.administrative,
		region : .location.region,
		subregion : .location.subregion,
		location_lat : .location.latlong[0],
		location_long : .location.latlong[1],
		
		date : .date.date,
		date_year : .date.year,
		date_month : .date.month,
		date_day : .date.day,
		
		day_index_0 : .date.index,
		day_index_1 : .day_index_1,
		day_index_10 : .day_index_10,
		day_index_100 : .day_index_100,
		day_index_1k : .day_index_1k,
		day_index_10k : .day_index_10k,
		day_index_peak : .day_index_peak,
		day_index_peak_confirmed : .day_index_peak_confirmed,
		day_index_peak_deaths : .day_index_peak_deaths,
		
		absolute_confirmed : .values.absolute.confirmed,
		absolute_deaths : .values.absolute.deaths,
		absolute_recovered : .values.absolute.recovered,
		absolute_infected : .values.absolute.infected,
		
		absolute_pop100k_confirmed : .values.absolute_pop100k.confirmed,
		absolute_pop100k_deaths : .values.absolute_pop100k.deaths,
		absolute_pop100k_recovered : .values.absolute_pop100k.recovered,
		absolute_pop100k_infected : .values.absolute_pop100k.infected,
		
		relative_confirmed : .values.relative.confirmed,
		relative_deaths : .values.relative.deaths,
		relative_recovered : .values.relative.recovered,
		relative_infected : .values.relative.infected,
		
		delta_confirmed : .values.delta.confirmed,
		delta_deaths : .values.delta.deaths,
		delta_recovered : .values.delta.recovered,
		delta_infected : .values.delta.infected,
		
		delta_pct_confirmed : .values.delta_pct.confirmed,
		delta_pct_deaths : .values.delta_pct.deaths,
		delta_pct_recovered : .values.delta_pct.recovered,
		delta_pct_infected : .values.delta_pct.infected,
		
		delta_pop100k_confirmed : .values.delta_pop100k.confirmed,
		delta_pop100k_deaths : .values.delta_pop100k.deaths,
		delta_pop100k_recovered : .values.delta_pop100k.recovered,
		delta_pop100k_infected : .values.delta_pop100k.infected,
		
		peak_pct_confirmed : .values.peak_pct.confirmed,
		peak_pct_deaths : .values.peak_pct.deaths,
		peak_pct_recovered : .values.peak_pct.recovered,
		peak_pct_infected : .values.peak_pct.infected,
		
		factbook_area : .factbook.area,
		factbook_population : .factbook.population,
		factbook_death_rate : .factbook.death_rate,
		factbook_median_age : .factbook.median_age,
		
	}
)
| .[]
