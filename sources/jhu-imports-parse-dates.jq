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
)
| sort_by (.date)
| map ({key : .key, value : .})
| from_entries
