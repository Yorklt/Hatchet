class_name TIP_BREAK
extends TIP


func transcript(
		_params: Array[PaneruParam],
		) -> void:
	pass


func reverse_into_paneru_params(
		_params: Array[PaneruParam],
		) -> void:
	return


func to_edit_lines(_last_begin: Komando.Type) -> String:
	var text: String = ""

	text += "break"

	return text


func from_edit_lines(dst_error_text: Array[String], edit_lines: Array[TIPEditLine], line_idx: int) -> int:

	var word: String = ""
	var edit_line: TIPEditLine = null
	edit_line = edit_lines[line_idx]

	word = edit_line.try_get_next_word()
	if word != "break":
		dst_error_text.append("breakを期待したがそうなってない。: " + word)
		return -1

	line_idx += 1

	return line_idx
