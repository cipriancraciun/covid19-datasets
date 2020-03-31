.
| map (.date)
| unique
| map (
	. as $key
	| split ("-")
	| map (tonumber)
	| {
		key : $key,
		year : .[0],
		month : .[1],
		day : .[2],
	}
	| .date = (
		[.year, .month, .day]
		| map (tostring)
		| map (if ((. | length) == 1) then "0" + . else . end)
		| join ("-")
	)
	| .timestamp = (.date + "T00:00:00Z" | fromdateiso8601)
)
| sort_by (.timestamp)
| reduce .[] as $current ([null, []];
	.
	| .[0] as $previous
	| .[1] as $records
	| $current
	| if ($previous != null) then
		.index = ($previous.index + 1)
	else
		.index = 1
	end
	| if ($previous != null) then
		if ((.timestamp - $previous.timestamp - (24 * 3600)) | fabs | (. > 3600)) then
			. as $current
			| ["f1d8de3a", $previous.date, .date] | debug
			| $current
		else . end
	else . end
	| [., $records + [.]]
)
| .[1]
| map ({key : .key, value : .})
| from_entries
