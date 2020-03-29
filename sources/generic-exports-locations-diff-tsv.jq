.
| [
	([
		.[0]
		| to_entries | .[] | .key
	]),
	(.[] | [
		.
		| .dataset |= join (", ")
		| to_entries | .[] | .value
		| if ((. != null) and (. != false)) then tostring else "" end
	])
]
| .[]
| join ("\t")
