class_name PaneruParam
extends RefCounted

enum Type
{
	INVALID,
	INT,
	FLOAT,
	STRING,
	GUID,
	VARIABLE,
	LOCAL,
	ARRAY,
	SUPOTTO,
	JOKEN_ARG,
}

var param_type: PaneruParam.Type = PaneruParam.Type.INVALID
var v_int: int = 0
var v_float: float = 0.0
var v_str: String = ""
var v_jokens: Array[Joken] = []


static func is_type_literal(p_type: PaneruParam.Type) -> bool:
	if p_type == PaneruParam.Type.INT:
		return true
	if p_type == PaneruParam.Type.FLOAT:
		return true
	if p_type == PaneruParam.Type.STRING:
		return true
	if p_type == PaneruParam.Type.GUID:
		return true
	if p_type == PaneruParam.Type.SUPOTTO:
		return true
	return false


func to_text() -> String:
	var text: String = ""
	if param_type == PaneruParam.Type.INVALID:
		text += "INVALID"
	if param_type == PaneruParam.Type.INT:
		text += "INT"
		text += " "
		text += "%d" % v_int
	if param_type == PaneruParam.Type.FLOAT:
		text += "FLOAT"
		text += " "
		text += "%5.2f" % v_float
	if param_type == PaneruParam.Type.STRING:
		text += "STRING"
		text += " "
		text += v_str
	if param_type == PaneruParam.Type.GUID:
		text += "GUID"
		text += " "
		text += v_str
	if param_type == PaneruParam.Type.SUPOTTO:
		text += "SUPOTTO"
		text += " "
		text += v_str
	if param_type == PaneruParam.Type.VARIABLE:
		text += "VARIABLE"
		text += " "
		text += v_str
	if param_type == PaneruParam.Type.LOCAL:
		text += "LOCAL"
		text += " "
		text += v_str
	if param_type == PaneruParam.Type.ARRAY:
		text += "ARRAY"
		text += " "
		text += v_str
	if param_type == PaneruParam.Type.JOKEN_ARG:
		text += "JOKEN_ARG"
		text += " "
		text += "省略"



	return text
