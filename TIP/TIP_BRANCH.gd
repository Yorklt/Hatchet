class_name TIP_BRANCH
extends TIP


func transcript(
		_params: Array[PaneruParam],
		) -> void:

	block_type = TIP.BlockType.CONTINUE


func to_edit_lines(_last_begin: Komando.Type) -> String:
	var text: String = ""

	text += "picked"

	return text
