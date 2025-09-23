class_name TIP_ENDLOOP
extends TIP


func transcript(
		_params: Array[PaneruParam],
		) -> void:

	block_type = TIP.BlockType.END


func to_text(_last_begin: Komando.Type) -> String:
	var text: String = ""

	text += "endloop"

	return text
