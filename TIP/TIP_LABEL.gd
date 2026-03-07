class_name TIP_LABEL
extends TIP

var label_num: int = -1


func transcript(
		params: Array[PaneruParam],
		) -> void:

	var p_idx: int = 0

	# 時間
	label_num = params[p_idx].v_int


func reverse_into_paneru_params(
		params: Array[PaneruParam],
		) -> void:

	PaneruParam.add_int_to_params(params, label_num)


func to_edit_lines(_last_begin: Komando.Type) -> String:
	var text: String = ""
	text += "label"
	text += " "
	text += "%d" % label_num

	return text


func from_edit_lines(dst_error_text: Array[String], edit_lines: Array[TIPEditLine], line_idx: int) -> int:

	var word: String = ""
	var edit_line: TIPEditLine = null
	edit_line = edit_lines[line_idx]

	word = edit_line.try_get_next_word()
	if word != "label":
		dst_error_text.append("labelを期待したがgotoではない。: " + word)
		return -1

	# 直地の整数
	word = edit_line.try_get_next_word()
	var chokuchi: Chokuchi = Chokuchi.try_parse_edit_text(word)
	if chokuchi != null:
		if chokuchi.c_type == Chokuchi.Type.INT:
			label_num = chokuchi.v_int
		else:
			dst_error_text.append("labelの後が判別不能。直地だが整数でない。: " + word)
			return -1
	else:
		dst_error_text.append("labelの後が判別不能。直地でない。: " + word)
		return -1

	line_idx += 1

	return line_idx
