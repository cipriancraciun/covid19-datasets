map ({key : .aliases[], value : .code})
| group_by (.key)
| map (
	if ((. | length) == 1) then
		.[0]
	else
		["573886e0", .] | debug |
		empty
	end)
| (. + (
	{
		"chicago" : "IL",
	}
	| to_entries
))
| sort_by (.value)
| from_entries
