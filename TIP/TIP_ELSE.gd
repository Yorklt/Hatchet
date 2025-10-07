class_name TIP_ELSE
extends TIP


func transcript(
		_params: Array[PaneruParam],
		) -> void:

	block_type = TIP.BlockType.CONTINUE


func to_edit_lines(last_begin: Komando.Type) -> String:
	var text: String = ""

	if last_begin == Komando.Type.BOSSBATTLE:
		text += "defeated"
	else:
		text += "else"

	return text
