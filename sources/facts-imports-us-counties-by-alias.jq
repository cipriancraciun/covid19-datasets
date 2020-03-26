map ({key : .aliases[], value : .fips})
| group_by (.key)
| map (
	if ((. | length) == 1) then
		.[0]
	else
#		["979b352c", .] | debug |
		empty
	end)
| (. + (
	{
		"ma_brockton" : "25023",
		"mo_kansas_city" : "29095",
		"mn_leseur" : "27079",
		"nh_nashua" : "12057",
		"ak_soldotna" : "02122",
		"ak_sterling" : "02122",
		"ma_dukes_and_nantucket" : "25007",
	}
	| to_entries
))
| sort_by (.value)
| from_entries
