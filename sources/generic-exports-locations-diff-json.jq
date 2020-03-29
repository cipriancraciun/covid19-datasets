.
| map (to_entries | .[] | .value)

| map (
	select (
		(.country != .country_original) or
		(.province != .province_original) or
		(.administrative != .administrative_original) or
		false
	)
)

| group_by ([.key, .key_original])
| map (
	.[0] + {
		dataset : map (.dataset) | sort
	}
)

| map ({
	
	key,
	key_original,
	type,
	label : .label,
	
	country_code,
	country_different : (.country != .country_original),
	country_normalized : .country,
	country_original,
	
	province_different : (.province != .province_original),
	province_normalized : .province,
	province_original,
	
	administrative_different : (.administrative != .administrative_original),
	administrative_normalized : .administrative,
	administrative_original,
	
	region,
	subregion,
	
	us_state_code : .us_state.code,
	us_state_name : .us_state.name,
	us_county_fips : .us_county.fips,
	us_county_name : .us_county.name,
	
	dataset,
})

| sort_by ([.country_normalized, .type, .label, .province_normalized, .administrative_normalized, .key])
