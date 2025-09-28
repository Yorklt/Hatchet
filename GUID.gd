class_name GUID
extends RefCounted

var v_str: String = ""


static func create(new_str: String) -> GUID:
	var guid: GUID = GUID.new()
	guid.v_str = new_str
	return guid


func to_text() -> String:
	var text: String = ""
	if v_str == "":
		return "00000000-0000-0000-0000-000000000000"
	text += v_str
	return text


static func try_parse_text(text: String) -> GUID:
	# xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx
	if text.length() == 36 and text[8] == "-" and text[13] == "-" and text[18] == "-" and text[23] == "-":
		var guid: GUID = GUID.create(text)
		return guid
	return null
