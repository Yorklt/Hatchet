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


static func create_int(new_v_int: int) -> PaneruParam:
	var param: PaneruParam = PaneruParam.new()
	param.param_type = PaneruParam.Type.INT
	param.v_int = new_v_int
	return param


static func add_int_to_params(params: Array[PaneruParam], new_v_int: int) -> void:
	params.append(PaneruParam.create_int(new_v_int))


static func create_float(new_v_float: int) -> PaneruParam:
	var param: PaneruParam = PaneruParam.new()
	param.param_type = PaneruParam.Type.FLOAT
	param.v_float = new_v_float
	return param


static func create_str(new_v_str: String) -> PaneruParam:
	var param: PaneruParam = PaneruParam.new()
	param.param_type = PaneruParam.Type.STRING
	param.v_str = new_v_str
	return param


static func add_str_to_params(params: Array[PaneruParam], new_v_str: String) -> void:
	params.append(PaneruParam.create_str(new_v_str))


static func create_guid(new_guid: GUID) -> PaneruParam:
	var param: PaneruParam = PaneruParam.new()
	param.param_type = PaneruParam.Type.GUID
	if new_guid != null:
		param.v_str = new_guid.v_str
	else:
		param.v_str = "" # フェイルセーフ
	return param


static func add_guid_to_params(params: Array[PaneruParam], new_guid: GUID) -> void:
	params.append(PaneruParam.create_guid(new_guid))


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
