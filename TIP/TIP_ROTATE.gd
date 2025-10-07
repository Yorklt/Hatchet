class_name TIP_ROTATE
extends TIP

var dir_type: int = -1
var spec_angle: ValDesign = null
var force_cardinal: bool = false


func transcript(
		params: Array[PaneruParam],
		) -> void:

	var p_idx: int = 0
	var p_idx_next: Array[int] = []
	
	# 方向タイプ
	dir_type = params[p_idx].v_int
	p_idx += 1

	# 指定角度
	if dir_type == 8:
		spec_angle = ValDesign.parse_paneru_params(p_idx_next, params, p_idx)
		p_idx = p_idx_next[0]

	# 四方に丸める
	if params[p_idx].v_int == 0:
		force_cardinal = false
	else:
		force_cardinal = true
	p_idx += 1


func to_edit_lines(_last_begin: Komando.Type) -> String:
	var text: String = ""
	text += "[[イベ向き]]"

	text += " "
	if dir_type == 0:
		text += "<<上>>"
	if dir_type == 1:
		text += "<<下>>"
	if dir_type == 2:
		text += "<<左>>"
	if dir_type == 3:
		text += "<<右>>"
	if dir_type == 4:
		text += "<<明後日>>"
	if dir_type == 5:
		text += "<<近づく>>"
	if dir_type == 6:
		text += "<<遠ざかる>>"
	if dir_type == 7:
		text += "<<クルっと>>"
	if dir_type == 8:
		text += "<<指定方向>>"
		text += " "
		text += spec_angle.to_text()
	
	if force_cardinal == true:
		text += " "
		text += "<<四方のみ>>"
	
	return text



	
