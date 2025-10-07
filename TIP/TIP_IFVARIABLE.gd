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


func to_edit_lines(_last_begin: Komando.Type) -> String:
	var text: String = ""
	text += "if"
	text += " "

	text += hensu_l.to_text()

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

	text += design_r.to_text()



	return text
