class_name TIP
extends RefCounted

# TIP: Translated Ibento Paneru

enum BlockType
{
	NONE,
	BEGIN, # ifなど
	CONTINUE, # elseなど
	END, # endなど
}


var block_type: TIP.BlockType = TIP.BlockType.NONE
var original_komando_name: String = ""
var error_text_trans: String = ""


func transcript(
		_params: Array[PaneruParam],
		) -> void:
	pass


func to_edit_lines(_last_begin: Komando.Type) -> String:
	return original_komando_name + " DO NOT CALL THIS FUNC"


func reverse_into_paneru_params(
		_params: Array[PaneruParam],
		) -> void:
	pass


func from_edit_lines(
		_dst_error_text: Array[String],
		_edit_lines: Array[TIPEditLine],
		_line_idx: int,
		) -> int:
	return -1
