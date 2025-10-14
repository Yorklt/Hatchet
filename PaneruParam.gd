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
var error_text: String = ""


static func add_int_to_params(params: Array[PaneruParam], new_v_int: int) -> void:
	var param: PaneruParam = PaneruParam.new()
	param.param_type = PaneruParam.Type.INT
	param.v_int = new_v_int
	params.append(param)


static func add_float_to_params(params: Array[PaneruParam], new_v_float: float) -> void:
	var param: PaneruParam = PaneruParam.new()
	param.param_type = PaneruParam.Type.FLOAT
	param.v_float = new_v_float
	params.append(param)


static func add_str_to_params(params: Array[PaneruParam], new_v_str: String) -> void:
	var param: PaneruParam = PaneruParam.new()
	param.param_type = PaneruParam.Type.STRING
	param.v_str = new_v_str
	params.append(param)


static func add_guid_to_params(params: Array[PaneruParam], new_guid: GUID) -> void:
	var param: PaneruParam = PaneruParam.new()
	param.param_type = PaneruParam.Type.GUID
	if new_guid != null:
		param.v_str = new_guid.v_str
	else:
		param.v_str = "" # フェイルセーフ
	params.append(param)


static func add_variable_to_params(params: Array[PaneruParam], new_name: String) -> void:
	var param: PaneruParam = PaneruParam.new()
	param.param_type = PaneruParam.Type.VARIABLE
	param.v_str = new_name
	params.append(param)


static func add_hensu_to_params(params: Array[PaneruParam], new_hensu: Hensu) -> void:
	
	# TODO ここの処理はHensuクラスにやらせるのが筋
	if new_hensu.h_type == Hensu.Type.N:
		var param: PaneruParam = PaneruParam.new()
		param.param_type = PaneruParam.Type.VARIABLE
		param.v_str = new_hensu.h_name
		params.append(param)
	elif new_hensu.h_type == Hensu.Type.L:
		var param: PaneruParam = PaneruParam.new()
		param.param_type = PaneruParam.Type.LOCAL
		param.v_str = new_hensu.h_name
		params.append(param)
	elif new_hensu.h_type == Hensu.Type.A:
		var param: PaneruParam = PaneruParam.new()
		param.param_type = PaneruParam.Type.ARRAY	
		param.v_str = new_hensu.h_name
		params.append(param)
		if new_hensu.idx_type == Hensu.Type.I:
			var param2: PaneruParam = PaneruParam.new()
			param2.param_type = PaneruParam.Type.INT
			params.append(param2)
		else:
			var param2: PaneruParam = PaneruParam.new()
			if new_hensu.idx_type == Hensu.Type.N:
				param2.param_type = PaneruParam.Type.VARIABLE
			if new_hensu.idx_type == Hensu.Type.L:
				param2.param_type = PaneruParam.Type.LOCAL			
			param2.v_str = new_hensu.idx_h_name
			params.append(param2)


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


static func try_parse_edit_text(words: Array[String]) -> Array[PaneruParam]:

	var params: Array[PaneruParam] = []

	# 例
	# "INT 6"
	# param_type = INT, v_int = 6
	# "LOCAL ポーションの数"
	# param_type = LOCAL, v_str = "ポーションの数"

	var idx: int = 0
	for i in range(0, 99):
		if idx > words.size() - 1:
			break

		var param: PaneruParam = PaneruParam.new()
		param.param_type = PaneruParam.Type.INVALID

		if idx + 1 > words.size() - 1:
			# エラー
			# wordが2つペアになっていない
			param.error_text = "型と値のペアになっていない。"
			break

		var word0: String = words[idx + 0]
		var word1: String = words[idx + 1]
		idx += 2

		if word0 == "INVALID":
			param.param_type = PaneruParam.Type.INVALID

		elif word0 == "INT":
			param.param_type = PaneruParam.Type.INT
			if word1.is_valid_int() == true:
				param.v_int = word1.to_int()
			else:
				# エラー
				param.error_text = "INTの後の値が解析できない。"

		elif word0 == "FLOAT":
			param.param_type = PaneruParam.Type.FLOAT
			if word1.is_valid_float() == true:
				param.v_float = word1.to_float()
			else:
				# エラー
				param.error_text = "FLOATの後の値が解析できない。"

		elif word0 == "STRING":
			param.param_type = PaneruParam.Type.STRING
			param.v_str = word1

		elif word0 == "GUID":
			param.param_type = PaneruParam.Type.GUID
			var guid: GUID = GUID.try_parse_text(word1)
			if guid != null:
				param.v_str = guid.v_str
			else:
				# エラー
				param.error_text = "GUIDの後の値が解析できない。"

		elif word0 == "SUPOTTO":
			param.param_type = PaneruParam.Type.GUID
			param.v_str = word1

		elif word0 == "VARIABLE":
			param.param_type = PaneruParam.Type.VARIABLE
			param.v_str = word1

		elif word0 == "LOCAL":
			param.param_type = PaneruParam.Type.LOCAL
			param.v_str = word1

		elif word0 == "ARRAY":
			param.param_type = PaneruParam.Type.ARRAY
			param.v_str = word1

		elif word0 == "JOKEN_ARG":
			param.param_type = PaneruParam.Type.JOKEN_ARG
			param.v_str = word1 # TBD

		params.append(param)

	return params


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
