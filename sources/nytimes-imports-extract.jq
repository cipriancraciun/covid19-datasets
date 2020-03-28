.
| .records

| map (
	if ((.dataset == "us-states") or (.dataset == "us-counties")) then
		{
			dataset : ("nytimes/" + .dataset),
			country_region : "United States",
			province_state : .state | (if ((. != null) and (. != "")) then . else null end),
			admin2 :
				(if (.dataset == "us-counties") then
					.county | (if ((. != null) and (. != "")) then . else null end)
				else null end),
			fips :
				(if (.dataset == "us-counties") then
					.fips__normalized | (if ((. != null) and (. != "")) then . else null end)
				else null end),
			date : .date | (if ((. != null) and (. != "")) then . else null end),
			values : {
				confirmed : .cases | (if ((. != null) and (. != "") and (. != 0)) then . else null end),
				deaths : .deaths | (if ((. != null) and (. != "") and (. != 0)) then . else null end),
			},
		}
	else
		["460f41de", .] | debug |
		empty
	end
)

| sort_by ([.dataset, .country_region, .province_state, .admin2, .fips, .date])
