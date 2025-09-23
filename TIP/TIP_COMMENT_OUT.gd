class_name TIP_COMMENT_OUT
extends TIP


var hensu_l : Hensu = null
var op_type: int = -1
var design_r: ValDesign = null


func transcript(
		_params: Array[PaneruParam],
		) -> void:	
	block_type = TIP.BlockType.BEGIN

func to_text(_last_begin: Komando.Type) -> String:
	var text: String = ""
	text += "exclude"
	return text
