.

| (
	map (
		.keys
		| to_entries
		| .[]
	)
	| unique
	| from_entries
) as $keys

| (
	map (
		.dataset as $dataset
		| .records
		| map (.dataset = $dataset)
	)
	| add
) as $records

| {
	keys : $keys,
	records : $records,
}
