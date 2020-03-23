.
| map (
	.values = {absolute : .values}
	| .values.absolute.confirmed |= (. // 0)
	| .values.absolute.recovered |= (. // 0)
	| .values.absolute.deaths |= (. // 0)
)
| map (
	.values.absolute.infected = (.values.absolute.confirmed - .values.absolute.recovered - .values.absolute.deaths)
)
| map (
	if (.values.absolute.confirmed != 0) then
		.values.relative = (
			.values.absolute
			| {
				recovered : ((.recovered / .confirmed) * 100),
				deaths : ((.deaths / .confirmed) * 100),
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
		| if ((.values.absolute.confirmed >= 1000) or ($previous.day_index_1000 != null)) then
			.day_index_1000 = (($previous.day_index_1000 // 0) + 1)
		else . end
		| {
			previous : .,
			records : ($records + [.]),
		}
	)
| .records
| map (select (.day_index_1 != null))
