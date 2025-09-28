class_name Supotto
extends RefCounted

var v_str: String = ""


static func create(new_str: String) -> Supotto:
	var supotto: Supotto = Supotto.new()
	supotto.v_str = new_str
	return supotto


func to_text() -> String:
	var text: String = ""
	if v_str == "":
		return "???"
	text += v_str
	return text


static func try_parse_text(text: String) -> Supotto:
	var supotto: Supotto = Supotto.create(text)
	return supotto
