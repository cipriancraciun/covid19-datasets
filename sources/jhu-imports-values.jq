.

| map (
	.location = (
			[
				(.country_region | if (. != "") then . else null end),
				(.province_state | if (. != "") then . else null end),
				(.admin2 | if (. != "") then . else null end),
				(.fips | if (. != "") then . else null end)
			]
			| crypto_md5
			| $locations[.])
	| if (.location == null) then
		["1cc7c3fa", .] | debug |
		.
	else . end
)
| map ({
	location,
	date,
	values,
})

| map (
	.date = $dates[.date]
	| del (.date.key)
	| if (.date == null) then
		["e832a6ba", .] | debug |
		.
	else . end
)

| group_by ([.location.key, .date.date])
| map (
	. as $records
	| .[0]
	| .values = (
		$records
		| map (.values | to_entries | .[])
		| group_by (.key)
		| map ({
			key : .[0].key,
			value : map (.value) | add,
		})
		| from_entries
	)
	| if (($records | length) > 1) then
		.location = (
			.location
			| del (.key_original)
			| del (.country_original)
			| del (.province_original)
			| del (.administrative_original)
			| .original = (
				$records
				| map (.location)
				| map ({key_original, country_original, province_original, administrative_original})
				| unique
				| sort_by ([.country_original, .province_original, .administrative_original, .key_original])
			)
			| .key_original = ("**" + (.original | crypto_md5))
		)
	else . end
)

| (. + (
	(
		[]
		+ map (
			select ((.location.type == "country") or (.location.type == "province") or (.location.type == "administrative"))
			| .location = (.location | {
					country, country_code, country_latlong,
					region, subregion,
					type : "total-country",
					label : .country,
				})
		)
		+ map (
			select ((.location.type == "province") or (.location.type == "administrative"))
			| .location = (.location | {
					country, country_code, country_latlong,
					province, province_latlong,
					region, subregion,
					type : "total-province",
					label : (.country + " / " + .province),
				})
		)
		+ map (
			select ((.location.type == "country") or (.location.type == "province") or (.location.type == "administrative"))
			| select (.location.country != null)
			| .location = (.location | {
					country : .region,
					region,
					type : "total-region",
					label : .region,
				})
		)
		+ map (
			select ((.location.type == "country") or (.location.type == "province") or (.location.type == "administrative"))
			| select (.location.country != null)
			| .location = (.location | {
					country : .subregion,
					region, subregion,
					type : "total-subregion",
					label : .subregion,
				})
		)
		+ map (
			.
			| .location = (.location | {
					country : "World",
					type : "total-world",
					label : "World",
				})
		)
	)
	| map (
		.location.key = ([.location.type, .location.country, .location.province, "(total)"] | crypto_md5)
	)
	| group_by ([.location.key, .date.date])
	| map (
		{
			location :
				.[0].location
				| {
					key : .key,
					type : .type,
					label : .label,
					country : .country,
					country_code : .country_code,
					country_latlong : .country_latlong,
					province : .province,
					region : .region,
					subregion : .subregion,
					administrative : "(total)",
					latlong : (.province_latlong // .country_latlong),
				},
			date : .[0].date,
			values :
				map (.values | to_entries | .[])
				| group_by (.key)
				| map ({
					key : .[0].key,
					value : map (.value) | add,
				})
				| from_entries,
		}
	)
))

| map (
	if (.location.type | ((. == "country") or (. == "total-country"))) then
		.factbook = $factbook[.location.country_code]
		| if (.factbook != null) then
			.factbook = (
				.factbook.fields
				| to_entries
				| map ({key : .key, value : .value.value})
				| from_entries
			)
		else . end
	else if (.location.type | ((. == "region") or (. == "subregion") or (. == "total-region") or (. == "total-subregion"))) then
		. as $data
		| .location.country as $name
		| $data.factbook = (
			$countries
			| map (
				select (
					(($data.location.type | ((. == "region") or (. == "total-region"))) and (.region == $name)) or
					(($data.location.type | ((. == "subregion") or (. == "total-subregion"))) and (.subregion == $name)) or
					false
				)
				| .code
			)
			| map (
				$factbook[.]
				| .fields
			)
			| {
				population : map (.population.value) | add,
				area : map (.area.value) | add,
			}
		)
	else if (.location.type | (. == "total-world")) then
		.factbook = (
			$factbook
			| to_entries
			| map (.value)
			| map (.fields)
			| {
				population : map (.population.value) | add,
				area : map (.area.value) | add,
			}
		)
	else if (.location.type | ((. == "province") or (. == "total-province"))) then
		if ((.location.country_code == "US") and (.location.province != "(mainland)")) then
			.factbook = (
				.location.province
				| . as $alias
				| if (. != null) then $us_states_by_alias[.] else . end
				| if (. != null) then $us_states[.] else . end
				| if (. == null) then ["504a3042", $alias] | debug | null else . end
				| if (. != null) then ({
					population : .population,
					area : .area,
				}) else {} end
			)
		else . end
	else . end end end end
	| if (.factbook == {}) then
		del (.factbook)
	else . end
)

| map (
	.data_key = (. | crypto_md5)
)

| sort_by ([.location.country, .date.date, .location.label, .location.province, .location.key])
