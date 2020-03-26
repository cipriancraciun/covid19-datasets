.records
| map (
	.
	
	| .county__simplified = (
			.county
			| gsub (", (Municipality|Consolidated Municipality|City|City and Borough|City and County|Town and County) of$"; "")
			| gsub (" (Municipality|County|Borough|Census Area|Parish)$"; "")
			| gsub ("St\\. "; "Saint ")
			| gsub ("Ste\\. "; "Sainte ")
		)
	| . as $data
	
	| {
		
		fips : .fips__normalized,
		
		name : .county__simplified,
		name_original : .county,
		name_normalized : .county__normalized,
		
		state_name : .state,
		state_code : .state_code,
		
		aliases :
			[
				.county,
				.county__normalized,
				.county__simplified,
				.fips__normalized,
				(.fips__normalized | tonumber | tostring)
			]
			| map (
				.,
				gsub ("^Saint "; "St. "),
				gsub ("^Sainte "; "Ste. "),
				gsub ("^saint "; "st. "),
				gsub ("^sainte "; "ste. "),
				gsub (" of$"; "")
			)
			| map (select ((. != null) and (. != "")))
			| unique
			| map (
				.,
				($data.state_code + " / " + .),
				($data.state + " / " + .),
				(. + ", " + $data.state_code),
				(. + ", " + $data.state)
			)
			| map (
				.,
				(. | ascii_downcase | gsub ("[^a-z0-9]+"; "_") | gsub ("(^_+)|(_+$)"; ""))
			)
			| unique,
	}
)
| sort_by (.fips)
| map ({key : .fips, value : .})
| from_entries
