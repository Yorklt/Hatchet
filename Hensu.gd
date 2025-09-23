class_name Hensu
extends Node

# ノーマル変数、ローカル変数、配列などの指定を包括的に扱う

enum Type
{
	N,
	L,
	A,
	S, # セーブ間共有変数は、ツール外ではNと区別が付かない
	I, # 添え字のリテラル整数
}

var h_type: Hensu.Type = Hensu.Type.N
var h_name: String = ""
var idx_type: Hensu.Type = Hensu.Type.I
var idx_h_name: String = ""
var idx_int: int = 0


static func paneru_param_type_to_hensu_type(param_type: PaneruParam.Type) -> Hensu.Type:
	if param_type == PaneruParam.Type.VARIABLE:
		return Hensu.Type.N
	if param_type == PaneruParam.Type.LOCAL:
		return Hensu.Type.L
	if param_type == PaneruParam.Type.ARRAY:
		return Hensu.Type.A
	return Hensu.Type.N


static func paneru_param_type_to_idx_type(param_type: PaneruParam.Type) -> Hensu.Type:
	if param_type == PaneruParam.Type.INT:
		return Hensu.Type.I
	if param_type == PaneruParam.Type.VARIABLE:
		return Hensu.Type.N
	if param_type == PaneruParam.Type.LOCAL:
		return Hensu.Type.L
	if param_type == PaneruParam.Type.ARRAY:
		return Hensu.Type.A
	return Hensu.Type.N


static func parse_paneru_params(p_idx_next: Array[int], params: Array[PaneruParam], p_idx: int) -> Hensu:

	p_idx_next.resize(1)
	var hensu: Hensu = Hensu.new()

	hensu.h_type = Hensu.paneru_param_type_to_hensu_type(params[p_idx].param_type)
	hensu.h_name = params[p_idx].v_str
	p_idx += 1
	
	if hensu.h_type == Hensu.Type.A:
	
		# 添え字
		hensu.idx_type = Hensu.paneru_param_type_to_idx_type(params[p_idx].param_type)
		if hensu.idx_type == Hensu.Type.I:
			hensu.idx_int = params[p_idx].v_int
		else:
			hensu.idx_h_name = params[p_idx].v_str
		p_idx += 1

	p_idx_next[0] = p_idx
	return hensu


func to_text() -> String:
	var text: String = ""
	if h_type == Hensu.Type.N:
		if h_name.left(2) != "N:":
			text += "N:"
		text += h_name
	elif h_type == Hensu.Type.L:
		if h_name.left(2) != "L:":
			text += "L:"
		text += h_name
	elif h_type == Hensu.Type.A:
		if h_name.left(2) != "A:":
			text += "A:"
		text += h_name
		text += "["
		if idx_type == Hensu.Type.I:
			text += "%d" % idx_int
		else:
			if idx_type == Hensu.Type.N:
				if idx_h_name.left(2) != "N:":
					text += "N:"
				text += idx_h_name
			elif idx_type == Hensu.Type.L:
				if idx_h_name.left(2) != "L:":
					text += "L:"
				text += idx_h_name
			else:
				text += "???:"
				text += idx_h_name
		text += "]"
	else:
		text += "h_type_ERROR" + "%d" % h_type

	return text
