class_name TIP_COMMENT_OUT
extends TIP


func transcript(
		_params: Array[PaneruParam],
		) -> void:	
	block_type = TIP.BlockType.BEGIN


func reverse_into_paneru_params(
		_params: Array[PaneruParam],
		) -> void:
	return


func to_edit_lines(_last_begin: Komando.Type) -> String:
	var text: String = ""
	text += "exclude"
	return text

func from_edit_lines(dst_error_text: Array[String], edit_lines: Array[TIPEditLine], line_idx: int) -> int:

	var word: String = ""
	var edit_line: TIPEditLine = null
	edit_line = edit_lines[line_idx]

	word = edit_line.try_get_next_word()
	if word != "exclude":
		dst_error_text.append("excludeを期待したが違う。: " + word)
		return -1

	line_idx += 1

	return line_idx
