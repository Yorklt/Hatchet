class_name Chokuchi
extends RefCounted

enum Type
{
	INT,
	FLOAT,
	STRING,
	#GUID,
	#SUPOTTO,
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
	#elif params[p_idx].param_type == PaneruParam.Type.GUID:
		#chokuchi.c_type = Chokuchi.Type.GUID
		#chokuchi.v_str = params[p_idx].v_str
	#elif params[p_idx].param_type == PaneruParam.Type.SUPOTTO:
		#chokuchi.c_type = Chokuchi.Type.SUPOTTO
		#chokuchi.v_str = params[p_idx].v_str

	return chokuchi


func add_to_paneru_params(params: Array[PaneruParam]) -> void:
	
	if c_type == Chokuchi.Type.INT:
		var param: PaneruParam = PaneruParam.new()
		param.param_type = PaneruParam.Type.INT
		param.v_int = v_int
		params.append(param)
	
	if c_type == Chokuchi.Type.FLOAT:
		var param: PaneruParam = PaneruParam.new()
		param.param_type = PaneruParam.Type.FLOAT
		param.v_float = v_float
		params.append(param)
	
	if c_type == Chokuchi.Type.STRING:
		var param: PaneruParam = PaneruParam.new()
		param.param_type = PaneruParam.Type.STRING
		param.v_str = v_str
		params.append(param)


func to_edit_text() -> String:
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
		text += "\"" + v_str + "\""
	#elif c_type == Chokuchi.Type.GUID:
		#text += v_str
	#elif c_type == Chokuchi.Type.SUPOTTO:
		#text += v_str

	return text


static func try_parse_edit_text(text: String) -> Chokuchi:
	var chokuchi: Chokuchi = null
	chokuchi = Chokuchi.try_parse_edit_text_to_int(text)
	if chokuchi != null:
		return chokuchi
	chokuchi = Chokuchi.try_parse_edit_text_to_float(text)
	if chokuchi != null:
		return chokuchi
	chokuchi = Chokuchi.try_parse_edit_text_to_string(text)
	if chokuchi != null:
		return chokuchi
	#chokuchi = Chokuchi.try_parse_text_to_guid(text)
	#if chokuchi != null:
		#return chokuchi
	#chokuchi = Chokuchi.try_parse_text_to_supotto(text)
	#if chokuchi != null:
		#return chokuchi
	return null


static func try_parse_edit_text_to_int(text: String) -> Chokuchi:
	if text.is_valid_int() == true:
		var chokuchi: Chokuchi = Chokuchi.new()
		chokuchi.c_type = Chokuchi.Type.INT
		chokuchi.v_int = text.to_int()
		return chokuchi
	return null


static func try_parse_edit_text_to_float(text: String) -> Chokuchi:
	# 例えば"3.14f"
	if text.right(1) == "f":
		text = text.substr(0, text.length() - 1)
	if text.is_valid_float() == true:
		var chokuchi: Chokuchi = Chokuchi.new()
		chokuchi.c_type = Chokuchi.Type.FLOAT
		chokuchi.v_float = text.to_float()
		return chokuchi
	return null


static func try_parse_edit_text_to_string(text: String) -> Chokuchi:
	# ダブルクォーテーションで囲まれている
	if text.length() >= 2 and text.left(1) == "\"" and text.right(1) == "\"":
		var chokuchi: Chokuchi = Chokuchi.new()
		chokuchi.c_type = Chokuchi.Type.STRING
		chokuchi.v_str = text.substr(1, text.length() - 2)
		return chokuchi
	return null


#static func try_parse_text_to_guid(text: String) -> Chokuchi:
	## xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx
	#if text.length() == 36 and text[8] == "-" and text[12] == "-" and text[16] == "-" and text[20] == "-":
		#var chokuchi: Chokuchi = Chokuchi.new()
		#chokuchi.c_type = Chokuchi.Type.GUID
		#chokuchi.v_str = text
		#return chokuchi
	#return null
#
#
#static func try_parse_text_to_supotto(text: String) -> Chokuchi:
	#var chokuchi: Chokuchi = Chokuchi.new()
	#chokuchi.c_type = Chokuchi.Type.SUPOTTO
	#chokuchi.v_str = text
	#return chokuchi
