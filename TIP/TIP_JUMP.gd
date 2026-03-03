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


func reverse_into_paneru_params(
		params: Array[PaneruParam],
		) -> void:

	PaneruParam.add_int_to_params(params, jump_type)

	if jump_type == TIP_JUMP.Type.BY_COHKUCHI:
		PaneruParam.add_chokuchi_to_params(params, label_num_chokuchi)

	elif jump_type == TIP_JUMP.Type.BY_HENSU:
		PaneruParam.add_hensu_to_params(params, label_num_hensu)


func to_edit_lines(_last_begin: Komando.Type) -> String:
	var text: String = ""
	text += "goto"
	text += " "

	if jump_type == TIP_JUMP.Type.BY_COHKUCHI:
		text += label_num_chokuchi.to_edit_text()

	if jump_type == TIP_JUMP.Type.BY_HENSU:
		text += label_num_hensu.to_edit_text()

	return text


func from_edit_lines(edit_lines: Array[TIPEditLine], line_idx: int) -> int:

	var word: String = ""
	var edit_line: TIPEditLine = null
	edit_line = edit_lines[line_idx]

	word = edit_line.try_get_next_word()
	if word != "goto":
		error_text += "gotoを期待したがgotoではない。: " + word + " "
		return -1

	# 直地か変数
	word = edit_line.try_get_next_word()
	var chokuchi: Chokuchi = Chokuchi.try_parse_edit_text(word)
	if chokuchi != null:
		jump_type = TIP_JUMP.Type.BY_COHKUCHI
		label_num_chokuchi = chokuchi
	else:
		var hensu: Hensu = Hensu.try_parse_edit_text(word)
		if hensu != null:
			jump_type = TIP_JUMP.Type.BY_HENSU
			label_num_hensu = hensu
		else:
			error_text += "gotoの後が判別不能。変数でも直地でもない。: " + word
			return -1

	line_idx += 1

	return line_idx
