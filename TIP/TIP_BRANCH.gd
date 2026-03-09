class_name TIP_BRANCH
extends TIP

var branch_idx: int = -1 # 最初の項目(CHOICES)が0で、BRANCHは1から

func transcript(
		params: Array[PaneruParam],
		) -> void:

	var p_idx: int = 0

	block_type = TIP.BlockType.CONTINUE

	# テキスト
	if params[p_idx].param_type == PaneruParam.Type.INT:
		branch_idx = params[p_idx].v_int
	else:
		error_text_trans += "最初の設定値の型がINTでない"


func reverse_into_paneru_params(
		params: Array[PaneruParam],
		) -> void:

	# 分岐番号
	if true:
		PaneruParam.add_int_to_params(params, branch_idx)


func to_edit_lines(_last_begin: Komando.Type) -> String:
	var text: String = ""

	text += "picked"

	# 分岐数
	if true:
		text += " "
		text += "%d" % branch_idx

	return text


func from_edit_lines(dst_error_text: Array[String], edit_lines: Array[TIPEditLine], line_idx: int) -> int:

	var word: String = ""
	var edit_line: TIPEditLine = null
	edit_line = edit_lines[line_idx]

	word = edit_line.try_get_next_word()
	if word != "picked" and word != "endpick":
		dst_error_text.append("pickedでもendpickでもない。: " + word)
		return -1

	word = edit_line.try_get_next_word()
	var chokuchi: Chokuchi = Chokuchi.try_parse_edit_text_to_int(word)
	if chokuchi == null:
		dst_error_text.append("pickedの後のワードが直値として判定不能。: " + word)
		return -1
	if chokuchi.c_type != Chokuchi.Type.INT:
		dst_error_text.append("pickedの後の直値がINTではない。: " + word)
		return -1
	branch_idx = chokuchi.v_int

	line_idx += 1

	return line_idx
