.
| map (.date)
| unique
| map (
	. as $key
	| split ("-")
	| {
		key : $key,
		year : .[2] | tonumber,
		month : .[0] | tonumber,
		day : .[1] | tonumber,
	}
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
