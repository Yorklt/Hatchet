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


func to_edit_lines(_last_begin: Komando.Type) -> String:
	return original_komando_name + " DO NOT CALL THIS FUNC"


func reverse_into_paneru_params(
		_params: Array[PaneruParam],
		) -> void:
	pass


func from_edit_lines(
		dst_line_idx_next: Array[int],
		_edit_lines: Array[TIPEditLine],
		line_idx: int,
		) -> void:
	dst_line_idx_next.resize(1)
	dst_line_idx_next[0] = line_idx + 1
