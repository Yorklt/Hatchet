class_name TIP_MESSAGE
extends TIP

var display_text: String = ""
var display_loc: int = 0 # 0 to 2, 4096 to 4104
var ibento_guid: String = "" # 吹き出しが特定イベントのとき
var has_window: bool = true

func transcript(
		params: Array[PaneruParam],
		) -> void:

	var p_idx: int = 0

	# テキスト
	if params[p_idx].param_type == PaneruParam.Type.STRING:
		display_text = params[p_idx].v_str
	else:
		error_text += "P1が文字列でない"

	p_idx += 1

	# 表示位置
	if params[p_idx].param_type == PaneruParam.Type.INT:
		display_loc = params[p_idx].v_int
	elif params[p_idx].param_type == PaneruParam.Type.GUID:
		ibento_guid = params[p_idx].v_str
	else:
		error_text += "表示位置が不明"

	p_idx += 1

	# ウィンドウの有無
	if params[p_idx].param_type == PaneruParam.Type.INT:
		if params[p_idx].v_int == 0:
			has_window = true
		elif params[p_idx].v_int == 1:
			has_window = false
		else:
			error_text += "ウィンドウの有無が解釈不能"
	else:
		error_text += "ウィンドウの有無が不明"


func to_text(_last_begin: Komando.Type) -> String:
	var text: String = ""
	text += "msg"
	text += " "

	if ibento_guid == "":

		if display_loc == 0:
			text += "<<上>>"
		elif display_loc == 1:
			text += "<<中>>"
		elif display_loc == 2:
			text += "<<下>>"
		elif display_loc == 4096:
			text += "<<吹き出しプレイヤー>>"
		elif display_loc == 4097:
			text += "<<吹き出しこのイベント>>"
		elif display_loc >= 4098 and display_loc <= 4104:
			text += "<<吹き出し" + "%d" % (display_loc - 4098 + 2) + "番目キャスト>>" # 2番目から8番目まで
		else:
			text += "<<ERROR>>"
	else:
		text += "<<吹き出し特定ベント>>"
		text += " "
		text += ibento_guid

	text += " "
	if has_window == true:
		text += "<<枠あり>>"
	else:
		text += "<<枠無し>>"
	text += "\n"
	# 複数行に分ける
	var lines: PackedStringArray = display_text.split("\\n", true)
	for k in range(0, lines.size()):
		text += lines[k]
		text += "\n"
	return text
