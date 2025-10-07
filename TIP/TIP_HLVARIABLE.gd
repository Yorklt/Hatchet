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
			text += rhs_params[i].to_text()



	return text
