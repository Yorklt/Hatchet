class_name TIP_CHOICES
extends TIP

var branch_count: int = -1 # キャンセル分岐含めた分岐数
var has_cancel_branch: bool = false
var item_params: Array[PickItemParam] = []
var display_loc: int = -1
var cancel_idx: int = -1
var initial_idx: int = -1


func transcript(
		params: Array[PaneruParam],
		) -> void:

	var p_idx: int = 0

	block_type = TIP.BlockType.BEGIN

	# 分岐の数（項目数＋キャンセル専用分岐）
	branch_count = params[p_idx].v_int
	p_idx += 1

	for i in range(0, branch_count):
		item_params.append(PickItemParam.new())

	# 表示テキスト（キャンセル専用分岐は架空の項目として扱われる）
	for i in range(0, branch_count):
		var item_text: String = params[p_idx].v_str
		item_params[i].text = item_text
		if item_text == "%%WhenCancel%%":
			has_cancel_branch = true
		p_idx += 1
	
	# 項目数は、キャンセル専用分岐があると1つ減る
	var item_count: int = branch_count
	if has_cancel_branch == true:
		item_count -= 1

	# 表示位置
	display_loc = params[p_idx].v_int
	p_idx += 1

	# 表示条件
	for i in range(0, item_count):
		if params[p_idx].param_type == PaneruParam.Type.JOKEN_ARG:
			item_params[i].disp_jokens = params[p_idx].v_jokens
			p_idx += 1
		else:
			# 条件が無い場合、空の「変数」となっている
			p_idx += 1

	# キャンセル時の項目（1起算、負でキャンセル無効、0で専用分岐）
	cancel_idx = params[p_idx].v_int
	p_idx += 1

	# 初期カーソル位置（1起算）
	initial_idx = params[p_idx].v_int
	p_idx += 1

	# 有効条件
	for i in range(0, item_count):
		if params[p_idx].param_type == PaneruParam.Type.JOKEN_ARG:
			item_params[i].enable_jokens = params[p_idx].v_jokens
			p_idx += 1
		else:
			# 条件が無い場合、空の「変数」となっている
			p_idx += 1


func reverse_into_paneru_params(
		params: Array[PaneruParam],
		) -> void:

	# 分岐数
	if true:
		PaneruParam.add_int_to_params(params, branch_count)

	# 表示テキスト（キャンセル専用分岐は架空の項目として扱われる）
	for i in range(0, branch_count):
		PaneruParam.add_str_to_params(params, item_params[i].text)
	
	# 項目数は、キャンセル専用分岐があると1つ減る
	var item_count: int = branch_count
	if has_cancel_branch == true:
		item_count -= 1

	# 表示位置
	PaneruParam.add_int_to_params(params, display_loc)

	# 表示条件
	for i in range(0, item_count):
		if item_params[i].disp_jokens.size() > 0:
			PaneruParam.add_jokens_to_params(params, item_params[i].disp_jokens)
			pass
		else:
			# 条件が無い場合、空の「変数」となっている
			PaneruParam.add_null_hensu_to_params(params)

	# キャンセル時の項目（1起算、負でキャンセル無効、0で専用分岐）
	PaneruParam.add_int_to_params(params, cancel_idx)

	# 初期カーソル位置（1起算）
	PaneruParam.add_int_to_params(params, initial_idx)

	# 有効条件
	for i in range(0, item_count):
		if item_params[i].enable_jokens.size() > 0:
			PaneruParam.add_jokens_to_params(params, item_params[i].enable_jokens)
			pass
		else:
			# 条件が無い場合、空の「変数」となっている
			PaneruParam.add_null_hensu_to_params(params)


func to_edit_lines(_last_begin: Komando.Type) -> String:
	var text: String = ""

	text += "pick"
	text += "\t"

	text += "\n"

	if display_loc == 0:
		text += "<<左上>>"
	elif display_loc == 1:
		text += "<<上>>"
	elif display_loc == 2:
		text += "<<右上>>"
	elif display_loc == 3:
		text += "<<左>>"
	elif display_loc == 4:
		text += "<<中央>>"
	elif display_loc == 5:
		text += "<<右>>"
	elif display_loc == 6:
		text += "<<左下>>"
	elif display_loc == 7:
		text += "<<下>>"
	elif display_loc == 8:
		text += "<<右下>>"
	else:
		text += "<<表示位置不明>>"
	text += "\t"

	text += "\n"

	text += "<<選択肢項目開始>>"
	text += "\n"

	for i in range(0, branch_count):

		var item_text: String =  item_params[i].text
		if item_text == "%%WhenCancel%%":
			text += "<<キャンセル専用分岐>>"
		else:
			text += item_text
		if initial_idx == i + 1:
			text += "\t"
			text += "<<初期位置>>"
		if cancel_idx == i + 1:
			text += "\t"
			text += "<<キャンセル時>>"
		text += "\n"

		for n in range(0, 2):

			var count: int = 0
			if n == 0:
				count = item_params[i].disp_jokens.size()
			if n == 1:
				count = item_params[i].enable_jokens.size()

			for k in range(0, count):
				
				var joken: Joken = item_params[i].disp_jokens[k]
				if n == 1:
					joken = item_params[i].enable_jokens[k]
				
				text += "\t"
				if n == 0:
					text += "<<表示条件>>"
				if n == 1:
					text += "<<有効条件>>"
				text += " "

				# しんどいので、Hensuがparseできるように書き出す。

				if joken.joken_type == Joken.Type.COND_TYPE_VARIABLE:
					if joken.rokaru_ref == true:
						text += "L:"
					else:
						text += "N:"
				elif joken.joken_type == Joken.Type.COND_TYPE_ARRAY_VAR:
					text += "A:"
				elif joken.joken_type == Joken.Type.COND_TYPE_SWITCH:
					if joken.rokaru_ref == true:
						text += "L:"
					else:
						text += "N:"
				elif joken.joken_type == Joken.Type.COND_TYPE_ARRAY_SW:
					text += "A:"
				text += joken.ref_name

				if (
						joken.joken_type == Joken.Type.COND_TYPE_ARRAY_VAR
						or
						joken.joken_type == Joken.Type.COND_TYPE_ARRAY_SW
						):
					text += "["
					if joken.pointa >= 0:
						text += "%d" % joken.pointa
					else:
						if joken.rokaru_ref == true:
							text += "L:"
							text += joken.pointa_name
						else:
							text += "N:"
							text += joken.pointa_name
					text += "]"

				text += " "
				if joken.operator == 0:
					text += "=="
				elif joken.operator == 1:
					text += "!="
				elif joken.operator == 2:
					text += ">="
				elif joken.operator == 3:
					text += "<="
				elif joken.operator == 4:
					text += ">"
				elif joken.operator == 5:
					text += "<"
				else:
					text += "ERROR"
				text += " "

				if (
						joken.joken_type == Joken.Type.COND_TYPE_SWITCH
						or
						joken.joken_type == Joken.Type.COND_TYPE_ARRAY_SW
						):
					# C系の言語の慣習とは論理が逆なので注意。ゼロでオン。
					if joken.option == 0:
						text += "オン"
					else:
						text += "オフ"
				else:
					text += "%d" % joken.option
				text += "\n"

	text += "<<選択肢項目終了>>"
	text += "\n"

	return text


func from_edit_lines(dst_error_text: Array[String], edit_lines: Array[TIPEditLine], line_idx: int) -> int:

	var word: String = ""
	var edit_line: TIPEditLine = null	
	edit_line = edit_lines[line_idx]

	word = edit_line.try_get_next_word()
	if word != "pick":
		dst_error_text.append("pickを期待したがpickではない。: " + word)
		return -1

	line_idx += 1
	if line_idx > edit_lines.size() - 1:
		dst_error_text.append("pickの後に行が十分に続いていない。")
		return -1
	edit_line = edit_lines[line_idx]

	word = edit_line.try_get_next_word()
	if word == "<<左上>>":
		display_loc = 0
	elif word == "<<上>>":
		display_loc = 1
	elif word == "<<右上>>":
		display_loc = 2
	elif word == "<<左>>":
		display_loc = 3
	elif word == "<<中央>>":
		display_loc = 4
	elif word == "<<右>>":
		display_loc = 5
	elif word == "<<左下>>":
		display_loc = 6
	elif word == "<<下>>":
		display_loc = 7
	elif word == "<<右下>>":
		display_loc = 8
	else:
		dst_error_text.append("表示位置が判別できない。: " + word)
		return -1

	line_idx += 1
	if line_idx > edit_lines.size() - 1:
		dst_error_text.append("pickの後に行が十分に続いていない。")
		return -1
	edit_line = edit_lines[line_idx]

	word = edit_line.try_get_next_word()
	if word != "<<選択肢項目開始>>":
		dst_error_text.append("<<選択肢項目開始>>を期待したが違う。: " + word)
		return -1

	line_idx += 1
	if line_idx > edit_lines.size() - 1:
		dst_error_text.append("pickの後に行が十分に続いていない。")
		return -1
	edit_line = edit_lines[line_idx]

	var item_param: PickItemParam = null
	branch_count = 0
	for i in range(0, 99):
		if line_idx > edit_lines.size() - 1:
			dst_error_text.append("<<選択肢項目終了>>が来る前に終わってしまった。")
			return -1
		edit_line = edit_lines[line_idx]
		line_idx += 1
		
		word = edit_line.try_get_next_word()
		if word == "<<選択肢項目終了>>":
			break

		var joken_type: int = -1

		if word == "<<表示条件>>":
			joken_type = 0
		elif word == "<<有効条件>>":
			joken_type = 1

		if joken_type < 0:

			# 条件ではないので、新しい項目

			branch_count += 1

			item_param = PickItemParam.new()
			item_params.append(item_param)

			if word == "<<キャンセル専用分岐>>":
				has_cancel_branch = true
				item_param.text = "%%WhenCancel%%"
			else:
				item_param.text = word

			for k in range(0, 99):

				word = edit_line.try_get_next_word()
				if word == "":
					break

				if word == "<<初期位置>>":
					initial_idx = branch_count - 1 + 1 # 1起算
				elif word == "<<キャンセル時>>":
					cancel_idx = branch_count - 1 + 1 # 1起算
				else:
					dst_error_text.append("選択肢項目のテキストの後に不明なワード。: " + word)
					return -1
		else:
			# 条件
			
			if item_param == null:
				dst_error_text.append("選択肢項目のが無いのに条件が始まった。")
				return -1

			var joken: Joken = Joken.new()
			joken.index = -1 # 謎の値

			# 左辺（続きは後で）
			word = edit_line.try_get_next_word()
			var lhs: Hensu = Hensu.try_parse_edit_text(word)
			if lhs == null:
				dst_error_text.append("条件の左辺が変数として判別不能。: " + word)
				return -1

			# オペレーター
			word = edit_line.try_get_next_word()
			if word == "==":
				joken.operator = 0
			elif word == "!=":
				joken.operator = 1
			elif word == ">=":
				joken.operator = 2
			elif word == "<=":
				joken.operator = 3
			elif word == ">":
				joken.operator = 4
			elif word == "<":
				joken.operator = 5
			else:
				dst_error_text.append("条件の等式が不明なワード。: " + word)
				return -1

			# 右辺（オン、オフ、整数のみ）
			var is_sw: bool = false
			word = edit_line.try_get_next_word()
			if word == "オン":
				is_sw = true
				joken.option = 0 # 真理値がC言語と逆
			elif word == "オフ":
				is_sw = true
				joken.option = 1 # 真理値がC言語と逆
			else:
				var chokuchi: Chokuchi = Chokuchi.try_parse_edit_text_to_int(word)
				if chokuchi.c_type != Chokuchi.Type.INT:
					dst_error_text.append("条件の右辺がオンオフでも整数でもない。: " + word)
					return -1
				joken.option = chokuchi.v_int

			# 左辺2
			var h_name: String = lhs.h_name
			if h_name.left(2) == "N:":
				if is_sw == true:
					joken.joken_type = Joken.Type.COND_TYPE_SWITCH
				else:
					joken.joken_type = Joken.Type.COND_TYPE_VARIABLE
				joken.rokaru_ref = false
			if h_name.left(2) == "A:":
				if is_sw == true:
					joken.joken_type = Joken.Type.COND_TYPE_ARRAY_SW
				else:
					joken.joken_type = Joken.Type.COND_TYPE_ARRAY_VAR
				joken.rokaru_ref = false # 添え字がローカルならtrueに変わる
			if h_name.left(2) == "L:":
				if is_sw == true:
					joken.joken_type = Joken.Type.COND_TYPE_SWITCH
				else:
					joken.joken_type = Joken.Type.COND_TYPE_VARIABLE
				joken.rokaru_ref = true
			joken.ref_name = lhs.h_name.right(-2)
			if lhs.h_type == Hensu.Type.A:
				if lhs.idx_type == Hensu.Type.I:
					joken.pointa = lhs.idx_int
				else:
					joken.pointa = -1
					var idx_h_name: String = lhs.idx_h_name
					if idx_h_name.left(2) == "L:":
						joken.pointa_name = lhs.idx_h_name.right(-2)
						joken.rokaru_ref = true
					else:
						joken.pointa_name = lhs.idx_h_name.right(-2)

			if joken_type == 0:
				item_param.disp_jokens.append(joken)
			elif joken_type == 1:
				item_param.enable_jokens.append(joken)

	return line_idx
