class_name Paneru
extends RefCounted

var komando_as_str: String = "" # デバッグ用途
var komando_type: Komando.Type
var params: Array[PaneruParam] = []
var tip: TIP = null
var tipt_error: String = ""

func to_edit_lines(last_begin: Komando.Type) -> String:
	var text: String = ""
	if tip == null:
		# 未対応の場合はダンプする
		text += "[[コマンド]]"
		text += " "
		text += komando_as_str
		text += " "
		for i in range(0, params.size()):
			text += " "
			text += params[i].to_text()
	else:
		text = tip.to_edit_lines(last_begin)
		# エラーがあれば
		if tip.error_text != "":
			text = " " + tip.error_text
	return text
