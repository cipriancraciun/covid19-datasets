.
| split ("\n")
| map (select (. != ""))
| .[1:]
| map (
	split ("    ")
	| map (
		gsub ("(^ +)|( +$)"; "")
		| select (. != "")
	)
	| {
		country_name : .[1],
		country_normalized : .[1] | ascii_downcase | gsub ("[^a-z0-9]+"; "_") | gsub ("(^_+)|(_+$)"; ""),
		fields : {
			($field) : {
				value : .[2] | gsub (","; "") | tonumber,
				estimate : .[3],
			},
		},
	}
	| .country_code = $countries_by_alias[.country_normalized]
	| if (.country_code != null) then
		.
	else
		# ["ac086fdc", .] | debug |
		empty
	end
)
| group_by (.country_code)
| map (
	if ((. | length) == 1) then
		.[0]
	else
		# ["3e27456e", .] | debug |
		empty
	end
)
