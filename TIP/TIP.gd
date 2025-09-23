class_name TIP
extends RefCounted

# TIP: Transcripted Ibento Paneru

enum BlockType
{
	NONE,
	BEGIN, # ifなど
	CONTINUE, # elseなど
	END, # endなど
}


var block_type: TIP.BlockType = TIP.BlockType.NONE
var original_komando_name: String = ""
var error_text: String = ""


func transcript(
		_params: Array[PaneruParam],
		) -> void:
	pass


func to_text(_last_begin: Komando.Type) -> String:
	return original_komando_name + " DO NOT CALL THIS FUNC"
