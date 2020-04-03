
import collections
import json
import re
import sys




def convert (_input, _output, _format) :
	
	_input = file (_input, "r")
	_output = file (_output, "w+")
	
	
	_input_decoder = json.JSONDecoder (object_pairs_hook = collections.OrderedDict)
	_input_data = _input.read ()
	_input_data = "[" + _input_data.replace ("}\n{", "},\n{") + "]"
	_records = _input_decoder.decode (_input_data)
	
	
	_field_types = {}
	_field_keys = []
	
	for _record in _records :
		
		for _field_key, _value in _record.iteritems () :
			
			if not _field_regex.match (_field_key) :
				raise Exception (("[0d9156a2]", _field_key))
			
			if _field_key in _field_types :
				_field_type, _field_null = _field_types[_field_key]
			else :
				_field_type = None
				_field_null = False
				_field_keys.append (_field_key)
			
			if _value is None :
				_field_null = True
			else :
				_value_type = type (_value)
				if _field_type is None :
					if _value_type in (int, float, str, unicode, bool) :
						_field_type = _value_type
					else :
						raise Exception (("[9a130bae]", _field_key, _value_type))
				elif _field_type is _value_type :
					pass
				else :
					if _field_type in (int, float) and _value_type in (int, float) :
						_field_type = float
					elif _field_type in (str, unicode) and _value_type in (str, unicode) :
						_field_type = unicode
					else :
						raise Exception (("[7060c5c8]", _field_key, _value_type, _field_type))
			
			_field_types[_field_key] = (_field_type, _field_null)
	
	_sql_table = "dataset";
	
	_sql_schema = []
	_sql_schema.append ("drop table if exists \"%s\";" % _sql_table)
	_sql_schema.append ("create table \"%s\" (" % _sql_table)
	for _field_index, _field_key in enumerate (_field_keys) :
		_field_type, _field_null = _field_types[_field_key]
		if _field_type is None :
			continue
			raise Exception (("[2cf877f8]", _field_key))
		_sql_line = "\t"
		_sql_line += "\"%s\"" % (_field_key)
		_sql_line += " "
		_sql_line += "%s" % (_field_types_sqlite[_field_type])
		if not _field_null :
			_sql_line += " not null"
		_sql_line += ","
		_sql_schema.append (_sql_line)
	_sql_schema.append ("\t" + "primary key (\"data_key\")")
	_sql_schema.append (");")
	_sql_schema = "\n\n--\n\n\n" + "\n".join (_sql_schema) + "\n\n--\n\n\n"
	
	_output.write (_sql_schema)
	
	_output.write ("insert into \"%s\"\n" % _sql_table)
	_output.write ("\t( " + ", ".join (["\"%s\"" % _field_key for _field_key in _field_keys if _field_types[_field_key][0] is not None]) + " )\n")
	_output.write ("values\n")
	for _index, _record in enumerate(_records) :
		_sql_values = []
		for _field_key in _field_keys :
			_field_type, _field_null = _field_types[_field_key]
			if _field_type is None :
				continue
				raise Exception (("[899b18a8]", _field_key))
			_value = _record[_field_key]
			if _value is None :
				_value = "null"
			elif isinstance (_value, (int, float)) :
				_value = str (_value)
			elif isinstance (_value, (str, unicode)) :
				_value = _value.replace ("'", "''")
				_value = "'%s'" % _value
			elif _value is True :
				_value = "true"
			elif _value is False :
				_value = "false"
			else :
				raise Exception (("[682148ee]", _field_key, _value))
			_sql_values.append (_value)
		_sql_values = ", ".join (_sql_values)
		if _index < (len (_records) - 1) :
			_output.write ("\t( " + _sql_values + " ),\n")
		else :
			_output.write ("\t( " + _sql_values + " )\n")
	_output.write (";")
	
	_input.close ()
	_output.close ()


_field_regex = re.compile ("^(?:[a-z0-9]+)(?:_[a-z0-9]+)*$")
_field_types_sqlite = {
		int : "integer",
		float : "real",
		str : "text",
		unicode : "text",
		bool : "boolean",
	}




if __name__ == "__main__" :
	convert (*sys.argv[1:])

