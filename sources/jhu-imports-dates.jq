.
| .keys
| to_entries
| map (select (.key | startswith ("_")))
| map (
	{
		key : .key,
		original : .value[0],
	}
	| (. + (
		.original
		| split ("/")
		| {
			year : (2000 + (.[2] | tonumber)),
			month : .[0] | tonumber,
			day : .[1] | tonumber,
		}
	))
	| .date = (
		[.year, .month, .day]
		| map (tostring)
		| map (if ((. | length) == 1) then "0" + . else . end)
		| join ("-")
	)
)
| sort_by (.date)
| map ({key : .key, value : .})
| from_entries
