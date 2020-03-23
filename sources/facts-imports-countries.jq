.
| map (
	. as $country
	| {
		
		code : .cca2,
		name : .name.common,
		
		region : .region,
		subregion : .subregion,
		latlong : .latlng,
		borders : .borders,
		area : .area,
		
		aliases :
			[
				.name.common, .name.official,
				(.name.native | to_entries | .[].value | [.official, .common]),
				.altSpellings,
				(.translations | to_entries | .[].value | [.official, .common])
			]
			| flatten
			| map (
				select (. != null)
				| (
					.,
					(. | ascii_downcase),
					(. | ascii_downcase | gsub ("[^a-z0-9]+"; "_") | gsub ("(^_+)|(_+$)"; ""))
				)
				| select ((. != null) and (. != ""))
				| select ((. | length) > 2)
			)
			| (. + (
					$country
					| [.cca2, .ccn3, .cca3, .cioc]
					| map (select ((. != null) and (. != "")))
					| map (ascii_downcase)
			))
			| unique
			,
		
	}
)
| map ({key : .code, value : .})
| sort_by (.key)
| from_entries
