class_name TIP_MESSAGE
extends TIP

var display_text: String = ""
var display_loc: int = 0 # 0 to 2, 4096 to 4104
var ibento_guid: GUID = null # 吹き出しが特定イベントのとき
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
		ibento_guid = GUID.create(params[p_idx].v_str)
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

func reverse_into_paneru_params(
		params: Array[PaneruParam],
		) -> void:

	# テキスト
	PaneruParam.add_str_to_params(params, display_text)

	# 表示位置
	if ibento_guid == null:
		PaneruParam.add_int_to_params(params, display_loc)
	else:
		PaneruParam.add_guid_to_params(params, ibento_guid)

	# ウィンドウの有無
	if has_window == true:
		PaneruParam.add_int_to_params(params, 0)
	else:
		PaneruParam.add_int_to_params(params, 1)


func to_edit_lines(_last_begin: Komando.Type) -> String:
	var text: String = ""
	text += "msg"
	text += " "

	if ibento_guid == null:

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
		text += ibento_guid.to_text()

	text += " "
	if has_window == true:
		text += "<<枠あり>>"
	else:
		text += "<<枠無し>>"

	text += "\n"

	# 複数行に分ける
	var lines: PackedStringArray = display_text.split("\\n", true)
	for k in range(0, lines.size()):
		text += "\"" + lines[k] + "\""
		text += "\n"
	return text


func from_edit_lines(edit_lines: Array[TIPEditLine], line_idx: int) -> int:

	# msg <<上>>
	# "こんにちは。"
	# "いい天気ですね。"

	var word: String = ""
	var edit_line: TIPEditLine = null
	edit_line = edit_lines[line_idx]

	word = edit_line.try_get_next_word()
	if word != "msg":
		error_text += "msgを期待したがmsgではない。: " + word + " "
		return -1
	
	for i in range(0, 99):
		word = edit_line.try_get_next_word()
		if word == "":
			break
		if word == "<<上>>":
			display_loc = 0
		elif word == "<<中>>":
			display_loc = 1
		elif word == "<<下>>":
			display_loc = 2
		elif word == "<<吹き出し特定ベント>>":
			word = edit_line.try_get_next_word()
			ibento_guid = GUID.create(word)
		elif word == "<<枠あり>>":
			has_window = true
		elif word == "<<枠無し>>":
			has_window = false
		else:
			# エラー
			error_text += "msgの後に不明なワード: " + word + " "
			pass

	for i in range(0, 99):
		line_idx += 1
		if line_idx > edit_lines.size() - 1:
			break
		edit_line = edit_lines[line_idx]
		word = edit_line.try_get_next_word()
		if word.length() >= 2 and word[0] == "\"" and word[word.length() - 1] == "\"":
			var striped: String = word.substr(1, word.length() - 2)
			if display_text.length() > 0:
				display_text += "/n"
			display_text += striped
		else:
			edit_line.loc = 0 # 次のパネルのために戻してあげる
			break

	return line_idx
