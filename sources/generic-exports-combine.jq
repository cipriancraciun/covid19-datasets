.
| map (.[])
| sort_by ([.location.country, .location.label, .location.province, .location.administrative, .location.key, .date.date, .dataset])
