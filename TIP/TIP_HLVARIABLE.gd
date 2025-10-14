class_name TIP_HLVARIABLE
extends TIP

var hensu_l : Hensu = null
var is_short_form: bool = false
var op_type: int = -1
var rhs_type: int = -1
var chokuchi_r: Chokuchi = null
var hensu_r : Hensu = null
var target_int_0: int = 0
var target_int_1: int = 0
var target_guid_0: String = ""
var rhs_params: Array[PaneruParam] = []

func transcript(
		params: Array[PaneruParam],
		) -> void:

	var p_idx: int = 0
	var p_idx_next: Array[int] = []

	# HLVARIABLEはなぜか整数0で始まる
	# なので最初の1つは飛ばす
	p_idx += 1

	# 左辺
	hensu_l = Hensu.parse_paneru_params(p_idx_next, params, p_idx)
	p_idx = p_idx_next[0]

	# わけがわからないのだけど、右辺地が整数の場合、
	# 右辺タイプ=整数(0)が省略されることがある。
	# 残りのパラメータの数で判断する。
	is_short_form = false
	if params[p_idx].param_type == PaneruParam.Type.INT:
		if params.size() - 1 == p_idx + 1:
			is_short_form = true

	# オペランドの決定
	op_type = -1
	var op_idx: int = params.size() - 1 # 最後がオペランドと決め打ちする
	if params[op_idx].param_type == PaneruParam.Type.INT:
		op_type = params[op_idx].v_int
	else:
		# エラー
		pass

	# 右辺
	if is_short_form == true:
		chokuchi_r = Chokuchi.parse_paneru_params(params, p_idx)
	else:

		rhs_type = -1
		if params[p_idx].param_type == PaneruParam.Type.INT:
			rhs_type = params[p_idx].v_int
		else:
			# エラー
			pass
		p_idx += 1

		# 直値
		if rhs_type == 0:
			chokuchi_r = Chokuchi.parse_paneru_params(params, p_idx)
			p_idx += 1

		# 乱数
		elif rhs_type == 1:
			target_int_0 = params[p_idx].v_int
			p_idx += 1
			target_int_1 = params[p_idx].v_int
			p_idx += 1

		# 変数
		elif rhs_type == 2:
			hensu_r = Hensu.parse_paneru_params(p_idx_next, params, p_idx)
			p_idx = p_idx_next[0]

		# アイテムの数
		elif rhs_type == 5:
			target_guid_0 = params[p_idx].v_str
			p_idx += 1

		# 操作キーの取得
		elif rhs_type == 12:
			target_int_0 = params[p_idx].v_int
			p_idx += 1

		# その他
		else:
			# ひとまず格納する
			for i in range(0, params.size()):
				if p_idx > params.size() - 1:
					break
				rhs_params.append(params[p_idx])
				p_idx += 1


func reverse_into_paneru_params(
		params: Array[PaneruParam],
		) -> void:

	# とりあえず短縮形は省略

	# HLVARIABLEはなぜか整数0で始まる
	if true:
		PaneruParam.add_int_to_params(params, 0)

	# 左辺
	if true:
		PaneruParam.add_hensu_to_params(params, hensu_l)

	# 右辺タイプ
	if true:
		PaneruParam.add_int_to_params(params, rhs_type)
		
	# 右辺の内容
	if rhs_type == 0:
		if chokuchi_r.c_type == Chokuchi.Type.INT:
			PaneruParam.add_int_to_params(params, chokuchi_r.v_int)
		if chokuchi_r.c_type == Chokuchi.Type.FLOAT:
			PaneruParam.add_float_to_params(params, chokuchi_r.v_float)
		if chokuchi_r.c_type == Chokuchi.Type.STRING:
			PaneruParam.add_str_to_params(params, chokuchi_r.v_str)

	elif rhs_type == 3:
		PaneruParam.add_hensu_to_params(params, hensu_r)

	# 代入演算子
	if true:
		PaneruParam.add_int_to_params(params, op_type)


func to_edit_lines(_last_begin: Komando.Type) -> String:
	var text: String = ""

	text += hensu_l.to_text()

	text += " "

	var op_text: String = ""
	if op_type < 0:
		op_text += " <OP不明>"
	elif op_type == 0:
		op_text += "="
	elif op_type == 1:
		op_text += "+="
	elif op_type == 2:
		op_text += "-="
	elif op_type == 3:
		op_text += "*="
	elif op_type == 4:
		op_text += "/="
	elif op_type == 5:
		op_text += "<<OP不明>>"
	elif op_type == 6:
		op_text += "mod="
	elif op_type == 7:
		op_text += "floor="
	else:
		op_text += "<<OP不明>>"
	# 省略形の場合は記号を変えて区別する
	if is_short_form == true:
		op_text.replace("=", ":=")
	text += op_text

	text += " "

	if rhs_type == 0:
		text += chokuchi_r.to_text()
	elif rhs_type == 1:
		text += "<<乱数>>"
		text += " "
		text += "%d" % target_int_0
		text += " "
		text += "%d" % target_int_1
	elif rhs_type == 2:
		text += hensu_r.to_text()
	elif rhs_type == 5:
		text += "<<アイテム数>>"
		text += " "
		text += target_guid_0
	elif rhs_type == 12:
		text += "<<操作キー>>"
		text += " "
		text += "%d" % target_int_0
	else:
		text += "<<その他>>"
		text += " "
		text += "%d" % rhs_type
		for i in range(0, rhs_params.size()):
			text += " "
			if rhs_params[i].error_text != "":
				text += "{{" + rhs_params[i].error_text + "}}"
			else:
				text += rhs_params[i].to_text()

	return text


static func _edit_word_to_op_type(word: String) -> int:
	if word == "=" or word == ":=":
		return 0
	if word == "+=" or word == "+:=":
		return 1
	if word == "-=" or word == "-:=":
		return 2
	if word == "*=" or word == "*:=":
		return 3
	if word == "/=" or word == "/:=":
		return 4
	return -1


static func _edit_word_to_rhs_type(word: String) -> int:
	if word == "<<乱数>>":
		return 1
	if word == "<<アイテム数>>":
		return 5
	if word == "<<操作キー>>":
		return 12
	if word == "<<その他>>":
		return -2 # TBD
	return -1


func from_edit_lines(dst_line_idx_next: Array[int], edit_lines: Array[TIPEditLine], line_idx: int) -> void:

	dst_line_idx_next.resize(1)
	dst_line_idx_next[0] = -1

	var word: String = ""

	var edit_line: TIPEditLine = null
	
	edit_line = edit_lines[line_idx]

	if true:
		word = edit_line.try_get_next_word()
		var hensu: Hensu = Hensu.try_parse_text(word)
		if hensu == null:
			error_text += "左辺が変数ではない。: " + word + " " + Hensu.parse_fail_msg + " "
			return
		hensu_l = hensu

	if true:
		word = edit_line.try_get_next_word()
		op_type = TIP_HLVARIABLE._edit_word_to_op_type(word)
		if op_type < 0:
			error_text += "変数の後の代入演算子が不明。: " + word + " "
			return

	word = edit_line.try_get_next_word()
	rhs_type = TIP_HLVARIABLE._edit_word_to_rhs_type(word)
	if rhs_type < 0:
		if rhs_type == -2:
			# 未対応の右辺タイプ
			word = edit_line.try_get_next_word()
			if word.is_valid_int() == false:
				error_text += "右辺タイプがその他だが、右辺のタイプ値が整数ではない。: " + word
				return
			rhs_type = word.to_int()
			for i in range(0, 99):
				var words: Array[String] = []
				for k in range(0, 99):
					word = edit_line.try_get_next_word()
					if word == "":
						break
					words.append(word)
				var params: Array[PaneruParam] =  PaneruParam.try_parse_edit_text(words)
				for k in range(0, params.size()):
					rhs_params.append(params[k])
		else:
			# 直地か変数、0か2
			var chokuchi: Chokuchi = Chokuchi.try_parse_text(word)
			if chokuchi != null:
				rhs_type = 0
				chokuchi_r = chokuchi
			else:
				var hensu: Hensu = Hensu.try_parse_text(word)
				if hensu != null:
					rhs_type = 2
					hensu_r = hensu
				else:
					error_text += "右辺が判別不能。変数でも直地でもない。: " + word
					return
	else:
		if rhs_type == 1:
			# 乱数
			word = edit_line.try_get_next_word()
			if word.is_valid_int() == true:
				PaneruParam.add_int_to_params(rhs_params, word.to_int())
			else:
				error_text += "乱数の最小値が不明。: " + word
				return
			word = edit_line.try_get_next_word()
			if word.is_valid_int() == true:
				PaneruParam.add_int_to_params(rhs_params, word.to_int())
			else:
				error_text += "乱数の最大値が不明。: " + word
				return
		elif rhs_type == 5:
			# アイテム数
			word = edit_line.try_get_next_word()
			var guid: GUID = GUID.try_parse_text(word)
			if guid != null:
				target_guid_0 = guid.v_str
		elif rhs_type == 12:
			# 操作キーの取得
			word = edit_line.try_get_next_word()
			if word.is_valid_int() == true:
				PaneruParam.add_int_to_params(rhs_params, word.to_int())
			else:
				error_text += "操作キーの取得で、対象が不明。: " + word
				return
		
		
		# TBD
		pass

	line_idx += 1
	dst_line_idx_next[0] = line_idx
