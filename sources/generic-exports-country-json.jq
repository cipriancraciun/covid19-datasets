.
| map (select (.location.country_code | (. != null)))
| map (select (.location.country_code | ascii_downcase | (. == $country)))
| map (select (.location.type | ((. == "total-country") or (. == "total-province"))))
