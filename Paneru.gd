class_name Paneru
extends RefCounted

var komando_text: String = "" # デバッグ用途
var komando_type: Komando.Type
var params: Array[PaneruParam] = []
var tip: TIP = null

func to_text(last_begin: Komando.Type) -> String:
	var text: String = ""
	if tip == null:
		text += komando_text
		text += " "
		for i in range(0, params.size()):
			text += " "
			text += params[i].to_text()
	else:
		text = tip.to_text(last_begin)
		if tip.error_text != "":
			text = " " + tip.error_text
	return text
