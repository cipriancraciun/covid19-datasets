.
| map (
	.values = {absolute : .values}
	| .values.absolute.confirmed |= (. // 0)
	| .values.absolute.recovered |= (. // 0)
	| .values.absolute.deaths |= (. // 0)
)
#| map (
#	select (
#		(.values.absolute.confirmed != 0)
#		or (.values.absolute.recovered != 0)
#		or (.values.absolute.deaths != 0)
#	)
#)
| map (
	.values.absolute.infected = (.values.absolute.confirmed - .values.absolute.recovered - .values.absolute.deaths)
)
| map (
	if (.factbook != null) then
		.values.absolute_pop1k = {
			confirmed : (.values.absolute.confirmed / (.factbook.population / 1000)),
			recovered : (.values.absolute.recovered / (.factbook.population / 1000)),
			deaths : (.values.absolute.deaths / (.factbook.population / 1000)),
			infected : (.values.absolute.infected / (.factbook.population / 1000)),
		}
		| .values.absolute_pop10k = {
			confirmed : (.values.absolute_pop1k.confirmed * 10),
			recovered : (.values.absolute_pop1k.recovered * 10),
			deaths : (.values.absolute_pop1k.deaths * 10),
			infected : (.values.absolute_pop1k.infected * 10),
		}
		| .values.absolute_pop100k = {
			confirmed : (.values.absolute_pop1k.confirmed * 100),
			recovered : (.values.absolute_pop1k.recovered * 100),
			deaths : (.values.absolute_pop1k.deaths * 100),
			infected : (.values.absolute_pop1k.infected * 100),
		}
	else . end
)
| map (
	if (.values.absolute.confirmed != 0) then
		.values.relative = (
			.values.absolute
			| {
				deaths : ((.deaths / .confirmed) * 100),
				recovered : ((.recovered / .confirmed) * 100),
				infected : ((.infected / .confirmed) * 100),
			}
		)
	else . end
)
| sort_by ([.location.key, .date.date])
| reduce
	.[] as $current
	(
		{previous : null, records : []}
	;
		.
		| .previous as $previous
		| .records as $records
		| (if (($previous != null) and ($previous.location.key == $current.location.key)) then $previous else null end) as $previous
		| $current
		| if ($previous != null) then
			.
			| .values.delta = {
				confirmed : ($current.values.absolute.confirmed - $previous.values.absolute.confirmed) | (if (. != 0) then . else null end),
				recovered : ($current.values.absolute.recovered - $previous.values.absolute.recovered) | (if (. != 0) then . else null end),
				deaths : ($current.values.absolute.deaths - $previous.values.absolute.deaths) | (if (. != 0) then . else null end),
				infected : ($current.values.absolute.infected - $previous.values.absolute.infected) | (if (. != 0) then . else null end),
			}
			| .values.delta_pct = {
				confirmed : (try (.values.delta.confirmed * 100.0 / $previous.values.absolute.confirmed) catch null) | (if (. != 0) then . else null end),
				recovered : (try (.values.delta.recovered * 100.0 / $previous.values.absolute.recovered) catch null) | (if (. != 0) then . else null end),
				infected : (try (.values.delta.infected * 100.0 / $previous.values.absolute.infected) catch null) | (if (. != 0) then . else null end),
				deaths : (try (.values.delta.deaths * 100.0 / $previous.values.absolute.deaths) catch null) | (if (. != 0) then . else null end),
			}
		else
			.
		end
		| if ((.values.absolute.confirmed >= 1) or ($previous.day_index_1 != null)) then
			.day_index_1 = (($previous.day_index_1 // 0) + 1)
		else . end
		| if ((.values.absolute.confirmed >= 10) or ($previous.day_index_10 != null)) then
			.day_index_10 = (($previous.day_index_10 // 0) + 1)
		else . end
		| if ((.values.absolute.confirmed >= 100) or ($previous.day_index_100 != null)) then
			.day_index_100 = (($previous.day_index_100 // 0) + 1)
		else . end
		| if ((.values.absolute.confirmed >= 1000) or ($previous.day_index_1k != null)) then
			.day_index_1k = (($previous.day_index_1k // 0) + 1)
		else . end
		| if ((.values.absolute.confirmed >= 10000) or ($previous.day_index_10k != null)) then
			.day_index_10k = (($previous.day_index_10k // 0) + 1)
		else . end
		| if (
				($previous == null)
				or (.values.absolute.confirmed != $previous.values.absolute.confirmed)
				or (.values.absolute.recovered != $previous.values.absolute.recovered)
				or (.values.absolute.deaths != $previous.values.absolute.deaths)
		) then
			{
				previous : .,
				records : ($records + [.]),
			}
		else
			{
				previous : .,
				records : $records,
			}
		end
	)
| .records
| map (
	if (.date.date >= "2020-03-23") then
		.
		| .values.absolute.recovered = null
		| .values.absolute.infected = null
		| .values.relative.recovered = null
		| .values.relative.infected = null
		| .values.delta.recovered = null
		| .values.delta.infected = null
		| .values.delta_pct.recovered = null
		| .values.delta_pct.infected = null
	else . end
)
| map (select (.day_index_1 != null))
| sort_by ([.location.country, .location.label, .location.province, .location.administrative, .location.key, .date.date])
| map (
	if ((.location.type == "country") or (.location.type == "province") or (.location.type == "administrative")) then
		. as $data
		| if (.values.delta.confirmed | ((. != null) and (. < 0))) then
#			["1426c7ed", .location.country, .date.date, .location.province, .values.delta, .] | debug |
			$data
		else . end
		| if (.values.delta.recovered | ((. != null) and (. < 0))) then
#			["b62e8b04", .location.country, .date.date, .location.province, .values.delta, .] | debug |
			$data
		else . end
		| if (.values.delta.deaths | ((. != null) and (. < 0))) then
#			["17a4869f", .location.country, .date.date, .location.province, .values.delta, .] | debug |
			$data
		else . end
	else . end
)
| map (
	.values = (
		.values
		| to_entries
		| map (
			.value = (
				.value
				| to_entries
				| map (select (.value | ((. != 0) and (. != null))))
				| from_entries
			)
		)
		| map (select (.value != {}))
		| from_entries
	)
)
