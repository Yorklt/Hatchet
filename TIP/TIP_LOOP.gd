class_name TIP_LOOP
extends TIP

var count: ValDesign = null
var counter: Hensu = null
var init_val: ValDesign = null

func transcript(
		params: Array[PaneruParam],
		) -> void:

	var p_idx: int = 0
	var p_idx_next: Array[int] = []
	
	block_type = TIP.BlockType.BEGIN

	if params[p_idx].v_int == 0:
		# 無限
		p_idx += 1
	else:
		# 回数あり
		p_idx += 1
		
		# LOOPは、回数だけ、カウンターあり、初期値もあり、の3パターンの形式が存在する。
		
		count = ValDesign.parse_paneru_params(p_idx_next, params, p_idx)
		p_idx = p_idx_next[0]
		
		if p_idx <= params.size() - 1:

			counter = Hensu.parse_paneru_params(p_idx_next, params, p_idx)
			p_idx = p_idx_next[0]

			if p_idx <= params.size() - 1:

				init_val = ValDesign.parse_paneru_params(p_idx_next, params, p_idx)
				p_idx = p_idx_next[0]


func reverse_into_paneru_params(
		params: Array[PaneruParam],
		) -> void:

	# 回数
	if count != null:
		PaneruParam.add_val_design_to_params(params, count)
	else:
		# 無限ループはゼロ
		PaneruParam.add_int_to_params(params, 0)

	# カウンタ
	if counter != null:
		PaneruParam.add_hensu_to_params(params, counter)

	# 初期値
	if init_val != null:
		PaneruParam.add_val_design_to_params(params, init_val)


func to_edit_lines(_last_begin: Komando.Type) -> String:
	var text: String = ""
	text += "loop"

	if counter != null:
		text += " "
		text += "for"
		text += " "
		text += counter.to_edit_text()
	if init_val != null:
		text += " "
		text += "from"
		text += " "
		text += init_val.to_edit_text()
	if count != null:
		text += " "
		text += "times"
		text += " "
		text += count.to_edit_text()
	return text


func from_edit_lines(dst_error_text: Array[String], edit_lines: Array[TIPEditLine], line_idx: int) -> int:

	# loop times 10
	# loop for L:i times 10
	# loop for L:i from N:初期値 times N:回数

	var word: String = ""
	var edit_line: TIPEditLine = null
	edit_line = edit_lines[line_idx]

	word = edit_line.try_get_next_word()
	if word != "loop":
		dst_error_text.append("loopを期待したがcallではない。: " + word)
		return -1

	for i in range(0, 99):
		word = edit_line.try_get_next_word()
		if word == "":
			break

		if word == "for":
			word = edit_line.try_get_next_word()
			counter = Hensu.try_parse_edit_text(word)
			if counter == null:
				dst_error_text.append("forの後が変数ではない。: " + word)
				return -1
		elif word == "from":
			word = edit_line.try_get_next_word()
			init_val = ValDesign.try_parse_edit_text(word)
			if init_val == null:
				dst_error_text.append("fromの後が直地でも変数でもない。: " + word)
				return -1
		elif word == "times":
			word = edit_line.try_get_next_word()
			count = ValDesign.try_parse_edit_text(word)
			if count == null:
				dst_error_text.append("timesの後が直地でも変数でもない。: " + word)
				return -1
		else:
			dst_error_text.append("loopのパラメータが不明（forでもfromでもtimesでもない）。: " + word)
			return -1

	line_idx += 1
	return line_idx
