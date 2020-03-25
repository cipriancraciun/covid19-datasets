.

| (
	map (
		.keys
		| to_entries
		| .[]
	)
	| group_by (.key)
	| map ({
		key : .[0].key,
		value : map (.value | .[]) | unique,
	})
	| from_entries
) as $keys

| (
	map (
		.keys_normalized
		| to_entries
		| .[]
	)
	| unique
	| from_entries
) as $keys_normalized

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
	keys_normalized : $keys_normalized,
	records : $records,
}
