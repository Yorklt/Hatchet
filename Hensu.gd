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


static var parse_fail_msg: String = ""

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


func add_to_paneru_params(params: Array[PaneruParam]) -> void:
	
	if h_type == Hensu.Type.N:
		var param: PaneruParam = PaneruParam.new()
		param.param_type = PaneruParam.Type.VARIABLE
		param.v_str = h_name
		params.append(param)

	elif h_type == Hensu.Type.L:
		var param: PaneruParam = PaneruParam.new()
		param.param_type = PaneruParam.Type.LOCAL
		# HensuからPaneruParamへの変換時にL:を外す
		if h_name.left(2) == "L:":
			param.v_str = h_name.right(-2)
		else:
			param.v_str = h_name
		params.append(param)

	elif h_type == Hensu.Type.A:
		var param: PaneruParam = PaneruParam.new()
		param.param_type = PaneruParam.Type.ARRAY	
		param.v_str = h_name
		params.append(param)
		if idx_type == Hensu.Type.I:
			var param2: PaneruParam = PaneruParam.new()
			param2.param_type = PaneruParam.Type.INT
			param2.v_int = idx_int
			params.append(param2)
		else:
			var param2: PaneruParam = PaneruParam.new()
			if idx_type == Hensu.Type.N:
				param2.param_type = PaneruParam.Type.VARIABLE
				param2.v_str = idx_h_name
			if idx_type == Hensu.Type.L:
				param2.param_type = PaneruParam.Type.LOCAL
				if idx_h_name.left(2) == "L:":
					param2.v_str = idx_h_name.right(-2)
				else:
					param2.v_str = idx_h_name
			params.append(param2)


func to_edit_text() -> String:
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


static func try_parse_edit_text(text: String) -> Hensu:
	
	if text.length() >= 3: # L:x なので最低3文字
		if text.left(2) == "N:":
			var hensu: Hensu = Hensu.new()
			hensu.h_type = Hensu.Type.N
			hensu.h_name = text
			return hensu
		elif text.left(2) == "L:":
			var hensu: Hensu = Hensu.new()
			hensu.h_type = Hensu.Type.L
			hensu.h_name = text
			return hensu
		elif text.length() >= 6 and text.left(2) == "A:": # A:x[x] なので最低6文字
			var b0: int = text.find("[", 0)
			var b1: int = text.find("]", 0)
			# [も]も有って、中身が1文字以上で、]は文字列の最後
			if b0 >= 0 and b1 >= 0 and b0 + 1 < b1 and text.length() - 1 == b1:
				var hensu: Hensu = Hensu.new()
				hensu.h_type = Hensu.Type.A

				# 配列変数の名前
				var h_str: String = text.substr(0, b0)
				hensu.h_name = h_str

				# 添え字
				# 例えば、xxxxx[xxx]なら [が5で、]が9、6から長さ3
				var idx_str: String = text.substr(b0 + 1, b1 - b0 - 1)
				if idx_str.length() >= 3 and idx_str.left(2) == "N:": # N:x なので最低3文字
					hensu.idx_type = Hensu.Type.N
					hensu.idx_h_name = idx_str
					return hensu
				elif idx_str.length() >= 3 and idx_str.left(2) == "L:":
					hensu.idx_type = Hensu.Type.L
					hensu.idx_h_name = idx_str
					return hensu
				elif idx_str.is_valid_int() == true:
					hensu.idx_type = Hensu.Type.I
					hensu.idx_int = idx_str.to_int()
					return hensu
				else:
					Hensu.parse_fail_msg = "添え字タイプが判別不可"
			else:
				Hensu.parse_fail_msg = "添え字の括弧の位置が不明"
		else:
			Hensu.parse_fail_msg = "変数タイプが判別不可"
	else:
		Hensu.parse_fail_msg = "3文字以上無い"

	return null
