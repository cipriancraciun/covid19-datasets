.
| map (.[])
| group_by (.country_code)
| map (
	. as $values
	| .[0]
	| .fields = (
		$values
		| map (.fields)
		| add
	)
)
| map ({key : .country_code, value : .})
| sort_by (.key)
| from_entries
