class_name TIP_IFVARIABLE
extends TIP


var hensu_l : Hensu = null
var op_type: int = -1
var design_r: ValDesign = null


func transcript(
		params: Array[PaneruParam],
		) -> void:

	var p_idx: int = 0
	var p_idx_next: Array[int] = []
	
	block_type = TIP.BlockType.BEGIN

	# 左辺
	hensu_l = Hensu.parse_paneru_params(p_idx_next, params, p_idx)
	p_idx = p_idx_next[0]

	# オペランド
	var op_idx: int = params.size() - 1 # 最後がオペランドと決め打ちする
	if params[op_idx].param_type == PaneruParam.Type.INT:
		op_type = params[op_idx].v_int
	else:
		error_text += "最後のPがINTではない"

	# 右辺
	design_r = ValDesign.parse_paneru_params(p_idx_next, params, p_idx)
	p_idx = p_idx_next[0]


func reverse_into_paneru_params(
		params: Array[PaneruParam],
		) -> void:

	# とりあえず短縮形は省略

	# 左辺
	if true:
		PaneruParam.add_hensu_to_params(params, hensu_l)

	# 左辺
	if true:
		if design_r.val_design_type == ValDesign.Type.LITERAL:
			if design_r.chokuchi.c_type == Chokuchi.Type.INT:
				PaneruParam.add_int_to_params(params, design_r.chokuchi.v_int)
			if design_r.chokuchi.c_type == Chokuchi.Type.FLOAT:
				PaneruParam.add_float_to_params(params, design_r.chokuchi.v_float)
			if design_r.chokuchi.c_type == Chokuchi.Type.STRING:
				PaneruParam.add_str_to_params(params, design_r.chokuchi.v_str)
		if design_r.val_design_type == ValDesign.Type.HENSU:
			PaneruParam.add_hensu_to_params(params, design_r.hensu)

	# 代入演算子
	if true:
		PaneruParam.add_int_to_params(params, op_type)


func to_edit_lines(_last_begin: Komando.Type) -> String:
	var text: String = ""
	text += "if"
	text += " "

	text += hensu_l.to_edit_text()

	var op_text: String = ""
	if op_type < 0:
		op_text += " <OP不明> "
	elif op_type == 0:
		op_text += " == "
	elif op_type == 1:
		op_text += " >= "
	elif op_type == 2:
		op_text += " <= "
	elif op_type == 3:
		op_text += " != "
	elif op_type == 4:
		op_text += " > "
	elif op_type == 5:
		op_text += " < "
	else:
		op_text += " <OP不明> "
	text += op_text

	text += design_r.to_edit_text()

	return text


static func _edit_word_to_op_type(word: String) -> int:
	if word == "==":
		return 0
	if word == ">=":
		return 1
	if word == "<=":
		return 2
	if word == "!=":
		return 3
	if word == ">":
		return 4
	if word == "<":
		return 5
	return -1



func from_edit_lines(edit_lines: Array[TIPEditLine], line_idx: int) -> int:

	var word: String = ""
	var edit_line: TIPEditLine = null
	edit_line = edit_lines[line_idx]

	if true:
		word = edit_line.try_get_next_word()
		if word != "if":
			error_text += "ifを期待したがifではない。: " + word
			return -1

	if true:
		word = edit_line.try_get_next_word()
		var hensu: Hensu = Hensu.try_parse_edit_text(word)
		if hensu == null:
			error_text += "左辺が変数ではない。: " + word + " " + Hensu.parse_fail_msg + " "
			return -1
		hensu_l = hensu

	if true:
		word = edit_line.try_get_next_word()
		op_type = TIP_IFVARIABLE._edit_word_to_op_type(word)
		if op_type < 0:
			error_text += "変数の後の代入演算子が不明。: " + word + " "
			return -1

	if true:
		word = edit_line.try_get_next_word()
		var vd: ValDesign = ValDesign.try_parse_edit_text(word)
		if vd == null:
			error_text += "右辺が値の指定（直地か変数）ではない。: " + word
			return -1
		design_r = vd

	line_idx += 1
	
	return line_idx
