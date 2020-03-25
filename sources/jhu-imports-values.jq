.
| .records
| map (
	.location = (
			[
				(.country_region | if (. != "") then . else null end),
				(.province_state | if (. != "") then . else null end),
				(.admin2 | if (. != "") then . else null end)
			]
			| crypto_md5
			| $locations[.])
	| if (.location == null) then
		["1cc7c3fa", .] | debug |
		.
	else . end
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
	map (select (.location.type != "unknown"))
	| (
		map (.location.type = "country")
		+ map (.location = {country : .location.region, type : "region"})
		+ map (.location = {country : .location.subregion, type : "subregion"})
	)
	| group_by ([.location.type, .location.country, .date])
	| map (
		{
			location : (
				.[0].location
				| .key = ([.country, "total", null] | crypto_md5)
				| .province = "total"
				| .province_latlong = null
				| .label = .country
				| .key_original = null
				| .country_original = null
				| .province_original = null
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

| map (
	if (.location.type == "country") then
		.factbook = $factbook[.location.country_code]
		| if (.factbook != null) then
			.factbook = (
				.factbook.fields
				| to_entries
				| map ({key : .key, value : .value.value})
				| from_entries
			)
		else . end
	else if ((.location.type == "region") or (.location.type == "subregion")) then
		. as $data
		| .location.country as $name
		| $data.factbook = (
			$countries
			| map (
				select (
					(($data.location.type == "region") and (.region == $name)) or
					(($data.location.type == "subregion") and (.subregion == $name)) or
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
	else . end end
)

| sort_by ([.location.country, .date.date, .location.label, .location.province, .location.key])
