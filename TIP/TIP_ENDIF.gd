class_name TIP_ENDIF
extends TIP


func transcript(
		_params: Array[PaneruParam],
		) -> void:

	block_type = TIP.BlockType.END


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
