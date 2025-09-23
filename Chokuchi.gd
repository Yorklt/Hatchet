class_name Chokuchi
extends RefCounted

enum Type
{
	INT,
	FLOAT,
	STRING,
	GUID,
	SUPOTTO,
}

var c_type: Chokuchi.Type = Chokuchi.Type.INT
var v_int: int = 0
var v_float: float = 0.0
var v_str: String = ""


static func parse_paneru_params(params: Array[PaneruParam], p_idx: int) -> Chokuchi:

	var chokuchi: Chokuchi = Chokuchi.new()

	if params[p_idx].param_type == PaneruParam.Type.INT:
		chokuchi.c_type = Chokuchi.Type.INT
		chokuchi.v_int = params[p_idx].v_int
	elif params[p_idx].param_type == PaneruParam.Type.FLOAT:
		chokuchi.c_type = Chokuchi.Type.FLOAT
		chokuchi.v_float = params[p_idx].v_float
	elif params[p_idx].param_type == PaneruParam.Type.STRING:
		chokuchi.c_type = Chokuchi.Type.STRING
		chokuchi.v_str = params[p_idx].v_str
	elif params[p_idx].param_type == PaneruParam.Type.GUID:
		chokuchi.c_type = Chokuchi.Type.GUID
		chokuchi.v_str = params[p_idx].v_str
	elif params[p_idx].param_type == PaneruParam.Type.SUPOTTO:
		chokuchi.c_type = Chokuchi.Type.SUPOTTO
		chokuchi.v_str = params[p_idx].v_str

	return chokuchi


func to_text() -> String:
	var text: String = ""
	if c_type == Chokuchi.Type.INT:
		text += "%d" % v_int
	elif c_type == Chokuchi.Type.FLOAT:
		if is_equal_approx(v_float, roundf(v_float)) == true:
			# 見やすさを優先して、fは付けないことにした。型が変わっちゃうことになるけどまあいいや！
			# text += "%df" % int(roundf(v_float))
			text += "%d" % int(roundf(v_float))
		else:
			text += "%5.2ff" % v_float
	elif c_type == Chokuchi.Type.STRING:
		text += v_str
	elif c_type == Chokuchi.Type.GUID:
		text += v_str
	elif c_type == Chokuchi.Type.SUPOTTO:
		text += v_str

	return text
