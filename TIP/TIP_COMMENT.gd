class_name TIP_COMMENT
extends TIP

var comment_text: String = ""


func transcript(
		params: Array[PaneruParam],
		) -> void:

	var p_idx: int = 0

	# テキスト
	if params[p_idx].param_type == PaneruParam.Type.STRING:
		comment_text = params[p_idx].v_str
	else:
		error_text += "P1が文字列でない"


func to_text(_last_begin: Komando.Type) -> String:
	var text: String = ""
	text += "//"
	text += " "
	text += comment_text
	return text + error_text
