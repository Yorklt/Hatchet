class_name TIP_BREAK
extends TIP


func transcript(
		_params: Array[PaneruParam],
		) -> void:
	pass


func to_text(_last_begin: Komando.Type) -> String:
	var text: String = ""

	text += "break"

	return text
