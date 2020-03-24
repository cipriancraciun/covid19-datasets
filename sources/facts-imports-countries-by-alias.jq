map ({key : .aliases[], value : .code})
| group_by (.key)
| map (
	if (. | length > 1) then
		# ["783ec68b", .] | debug |
		empty
	else
		.
	end)
| map (.[0])
| (. + (
	{
		"bahamas_the" : "BS",
		"cote_d_ivoire" : "CI",
		"gambia_the" : "GM",
		"guyana" : "GY", # ???
		"holy_see" : "VA", # ???
		"korea_south" : "KR",
		"sudan" : "SS", # ???
		"cruise_ship" : "US", # ???
		"the_bahamas" : "BS",
		"the_gambia" : "GM",
	}
	| to_entries
))
| sort_by (.value)
| from_entries
