class_name TIP_WAIT
extends TIP

var time: ValDesign = null

func transcript(
		params: Array[PaneruParam],
		) -> void:

	var p_idx: int = 0
	var p_idx_next: Array[int] = []

	# 時間
	time = ValDesign.parse_paneru_params(p_idx_next, params, p_idx)
	p_idx = p_idx_next[0]
	
	# WAITは最後に謎の整数(1)がある。不明。
	p_idx += 1


func reverse_into_paneru_params(
		params: Array[PaneruParam],
		) -> void:

	PaneruParam.add_val_design_to_params(params, time)


func to_edit_lines(_last_begin: Komando.Type) -> String:
	var text: String = ""
	text += "wait"
	text += " "
	text += time.to_edit_text()

	return text


func from_edit_lines(edit_lines: Array[TIPEditLine], line_idx: int) -> int:

	var word: String = ""
	var edit_line: TIPEditLine = null
	edit_line = edit_lines[line_idx]

	word = edit_line.try_get_next_word()
	if word != "wait":
		error_text += "waitを期待したがgotoではない。: " + word + " "
		return -1

	# 直地か変数
	word = edit_line.try_get_next_word()
	var val_design: ValDesign = ValDesign.try_parse_edit_text(word)
	if val_design != null:
		time = val_design
	else:
		error_text += "waitの後が判別不能。変数でも直地でもない。: " + word
		return -1

	line_idx += 1

	return line_idx
