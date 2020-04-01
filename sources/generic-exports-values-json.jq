.

| map (
	.values = {absolute : .values}
	| .values.absolute.confirmed |= (. // 0)
	| .values.absolute.recovered |= (. // 0)
	| .values.absolute.deaths |= (. // 0)
)

| sort_by ([.dataset, .location.key, .date.date])
| reduce
	.[] as $current
	(
		{previous : null, records : []}
	;
		.
		| .previous as $previous
		| .records as $records
		| (if (($previous != null) and ($previous.dataset == $current.dataset) and ($previous.location.key == $current.location.key)) then $previous else null end) as $previous
		| $current
		
		| if ((.dataset == "ecdc/worldwide") and ($previous != null)) then
			.
			| .values.absolute = {
				confirmed : (.values.absolute.confirmed + $previous.values.absolute.confirmed),
				recovered : (.values.absolute.recovered + $previous.values.absolute.recovered),
				deaths : (.values.absolute.deaths + $previous.values.absolute.deaths),
			}
		else . end
		
		| .values.absolute.infected = (.values.absolute.confirmed - .values.absolute.recovered - .values.absolute.deaths)
		
		| if ($previous != null) then
			.
			| .values.delta = {
				confirmed : (.values.absolute.confirmed - $previous.values.absolute.confirmed),
				recovered : (.values.absolute.recovered - $previous.values.absolute.recovered),
				deaths : (.values.absolute.deaths - $previous.values.absolute.deaths),
				infected : (.values.absolute.infected - $previous.values.absolute.infected),
			}
			| .values.delta_pct = {
				confirmed : (try (.values.delta.confirmed * 100.0 / $previous.values.absolute.confirmed) catch 0),
				recovered : (try (.values.delta.recovered * 100.0 / $previous.values.absolute.recovered) catch 0),
				infected : (try (.values.delta.infected * 100.0 / $previous.values.absolute.infected) catch 0),
				deaths : (try (.values.delta.deaths * 100.0 / $previous.values.absolute.deaths) catch 0),
			}
		else
			.
			| .values.delta = .values.absolute
		end
		
		| if ((.values.absolute.confirmed >= 1) or ($previous.day_index_1 != null)) then
			.day_index_1 = (if ($previous.day_index_1 != null) then $previous.day_index_1 + .date.index - $previous.date.index else 1 end)
		else . end
		| if ((.values.absolute.confirmed >= 10) or ($previous.day_index_10 != null)) then
			.day_index_10 = (if ($previous.day_index_10 != null) then $previous.day_index_10 + .date.index - $previous.date.index else 1 end)
		else . end
		| if ((.values.absolute.confirmed >= 100) or ($previous.day_index_100 != null)) then
			.day_index_100 = (if ($previous.day_index_100 != null) then $previous.day_index_100 + .date.index - $previous.date.index else 1 end)
		else . end
		| if ((.values.absolute.confirmed >= 1000) or ($previous.day_index_1k != null)) then
			.day_index_1k = (if ($previous.day_index_1k != null) then $previous.day_index_1k + .date.index - $previous.date.index else 1 end)
		else . end
		| if ((.values.absolute.confirmed >= 10000) or ($previous.day_index_10k != null)) then
			.day_index_10k = (if ($previous.day_index_10k != null) then $previous.day_index_10k + .date.index - $previous.date.index else 1 end)
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
				previous : $previous,
				records : $records,
			}
		end
	)
| .records

| (
	group_by (.dataset)
	| map (
		.[0].dataset as $records_dataset
		| group_by (.location.key)
		| map (
			.[0].location.key as $records_location_key
			| . as $records
			| ["confirmed", "recovered", "deaths", "infected"]
			| map (
				. as $metric
				| {
					key : $metric,
					value : (
						$records
						| map (select (.values.delta[$metric] != null))
						| map (select (.values.delta[$metric] > 0))
						| sort_by ([.values.delta[$metric], .date.index])
						| reverse
						| .[1:6]
						| (. | length) as $length
						| if ($length >= 1) then
							{
								date_index : map (.date.index) | add | (. / $length) | trunc,
								value : map (.values.delta[$metric]) | add | (. / $length),
							}
						else null end
					)
				}
			)
			| map (select (.value.value != null))
			| from_entries
			| [$records_location_key, .]
		)
		| map ({
			key : .[0],
			value : .[1],
		})
		| sort_by (.key)
		| from_entries
		| [$records_dataset, .]
	)
	| map ({
		key : .[0],
		value : .[1],
	})
	| sort_by (.key)
	| from_entries
) as $peak_values

| map (
	$peak_values[.dataset][.location.key] as $peak_values
	| .values.peak_pct = (
			.values.delta
			| to_entries
			| map (
				.value = (
					if ($peak_values[.key] != null) then
						((.value / $peak_values[.key].value) * 100)
					else null end)
			)
			| map (select (.value != null))
			| from_entries
		)
	| .day_index_peak_confirmed = (if ($peak_values.confirmed.date_index != null)
			then (.date.index - $peak_values.confirmed.date_index) else null end)
	| .day_index_peak_deaths = (if ($peak_values.deaths.date_index != null)
			then (.date.index - $peak_values.deaths.date_index) else null end)
	| .day_index_peak = (
			[.day_index_peak_confirmed, .day_index_peak_deaths]
			| map (select (. != null))
			| if (. != []) then
				((. | add) / (. | length)) | trunc
			else null end
		)
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

| map (select (.day_index_1 != null))

| sort_by ([.dataset, .location.country, .location.label, .location.province, .location.administrative, .location.key, .date.date])

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
