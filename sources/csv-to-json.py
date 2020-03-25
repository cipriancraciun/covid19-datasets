
import csv
import json
import re
import sys

import unidecode




def convert (_input, _output, _dataset) :
	
	_input = file (_input, "r")
	_output = file (_output, "w+")
	
	_reader = csv.DictReader (_input, dialect = "excel")
	
	_records = []
	_keys = {}
	_keys_reverse = {}
	for _record in _reader :
		for _key in _record.iterkeys () :
			_key_normalized = _normalize_key (_key)
			if _key_normalized not in _keys :
				if _key_normalized not in _keys :
					_keys[_key_normalized] = []
				_keys[_key_normalized].append (_key)
				_keys_reverse[_key] = _key_normalized
		_record = {_keys_reverse[_key] : _normalize_value (_value) for _key, _value in _record.iteritems ()}
		_records.append (_record)
	
	_data = {
			"dataset" : _dataset,
			"records" : _records,
			"keys" : _keys,
			"keys_normalized" : _keys_reverse,
		}
	
	json.dump (_data, _output, ensure_ascii = True, sort_keys = True, indent = 2, separators = (",", " : "))
	
	_input.close ()
	_output.close ()




def _normalize_key (_key) :
	
	if _key == "" :
		raise Exception (("[0974b480]", _key))
	
	global _normalize_key_cache
	if _key in _normalize_key_cache :
		return _normalize_key_cache[_key]
	
	_key = _key.decode ("utf-8")
	
	_normalized = unidecode.unidecode (_key)
	_normalized = _normalized.lower ()
	_normalized = _normalize_key_forbidden.sub ("_", _normalized)
	_normalized = _normalized.strip ("_")
	if _normalized[0] >= "0" and _normalized[0] <= "9" :
		_normalized = "_" + _normalized
	
	_normalize_key_cache[_key] = _normalized
	return _normalized

_normalize_key_cache = dict ()
_normalize_key_forbidden = re.compile ("[^A-Za-z0-9_]+")




def _normalize_value (_value) :
	
	if _value == "" :
		return None
	
	_value_lower = _value.lower ()
	
	if _value_lower == "true" or _value_lower == "yes" :
		return True
	elif _value_lower == "false" or _value_lower == "no" :
		return False
	
	try :
		return int (_value)
	except :
		pass
	
	try :
		return float (_value)
	except :
		pass
	
	_value = _value.decode ("utf-8")
#	_normalized = unidecode.unidecode (_value)
#	_normalized = _normalized.strip (" ")
	
	return _value




if __name__ == "__main__" :
	convert (*sys.argv[1:])

