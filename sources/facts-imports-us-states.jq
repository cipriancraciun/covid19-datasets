.records
| map (
	{
		
		code : .code,
		name : .name,
		name_normalized : .name__normalized,
		
		population : .population,
		area : .area,
		
		aliases : [
				.code,
				.code__normalized,
				.name,
				.name__normalized
			]
			| map (select ((. != null) and (. != "")))
			| unique,
	}
)
| sort_by (.code)
| map ({key : .code, value : .})
| from_entries
