class_name TIP_JUMP
extends TIP

enum Type
{
	BY_COHKUCHI,
	BY_HENSU,
}

var jump_type: TIP_JUMP.Type = TIP_JUMP.Type.BY_COHKUCHI
var label_num_chokuchi: Chokuchi = null
var label_num_hensu: Hensu = null


func transcript(
		params: Array[PaneruParam],
		) -> void:

	var p_idx: int = 0
	var p_idx_next: Array[int] = []

	# 指定タイプ
	if params[p_idx].v_int == 0:
		jump_type = TIP_JUMP.Type.BY_COHKUCHI
	else:
		jump_type = TIP_JUMP.Type.BY_HENSU
	p_idx += 1

	# ラベルの指定
	if jump_type == TIP_JUMP.Type.BY_COHKUCHI:
		label_num_chokuchi = Chokuchi.parse_paneru_params(params, p_idx)
		p_idx += 1
	if jump_type == TIP_JUMP.Type.BY_HENSU:
		label_num_hensu = Hensu.parse_paneru_params(p_idx_next, params, p_idx)
		p_idx = p_idx_next[0]


func to_edit_lines(_last_begin: Komando.Type) -> String:
	var text: String = ""
	text += "goto"
	text += " "

	if jump_type == TIP_JUMP.Type.BY_COHKUCHI:
		text += label_num_chokuchi.to_edit_text()

	if jump_type == TIP_JUMP.Type.BY_HENSU:
		text += label_num_hensu.to_edit_text()

	return text
