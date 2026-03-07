class_name TIP_ENDIF
extends TIP


func transcript(
		_params: Array[PaneruParam],
		) -> void:

	block_type = TIP.BlockType.END


func reverse_into_paneru_params(
		_params: Array[PaneruParam],
		) -> void:
	return


func to_edit_lines(last_begin: Komando.Type) -> String:
	var text: String = ""

	if last_begin == Komando.Type.IFVARIABLE:
		text += "endif"
	elif last_begin == Komando.Type.CHOICES:
		text += "endpick"
	elif last_begin == Komando.Type.COMMENT_OUT:
		text += "endex"
	elif last_begin == Komando.Type.BOSSBATTLE:
		text += "endcombat"
	else:
		text += "end???"

	return text


func from_edit_lines(dst_error_text: Array[String], edit_lines: Array[TIPEditLine], line_idx: int) -> int:

	var word: String = ""
	var edit_line: TIPEditLine = null
	edit_line = edit_lines[line_idx]

	word = edit_line.try_get_next_word()
	var is_valid: bool = false
	if word == "endif":
		is_valid = true
	if word == "endpick":
		is_valid = true
	if word == "endex":
		is_valid = true
	if word == "endcombat":
		is_valid = true
	if word == "end???":
		is_valid = true

	if is_valid == false:
		dst_error_text.append("endifでもendpickでもendexでもendcombatでもない。: " + word)
		return -1

	line_idx += 1

	return line_idx
