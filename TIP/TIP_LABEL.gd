class_name TIP_LABEL
extends TIP

var label_num: int = -1


func transcript(
		params: Array[PaneruParam],
		) -> void:

	var p_idx: int = 0

	# 時間
	label_num = params[p_idx].v_int


func to_edit_lines(_last_begin: Komando.Type) -> String:
	var text: String = ""
	text += "label"
	text += " "
	text += "%d" % label_num

	return text
