class_name TIP_EXEC
extends TIP

var guid: GUID = null
var does_wait_finish: bool = false
var does_wait_untill_begin: bool = false
var does_begin_at_next_frame: bool = false

func transcript(
		params: Array[PaneruParam],
		) -> void:

	var p_idx: int = 0

	# テキスト
	if params[p_idx].param_type == PaneruParam.Type.GUID:
		guid = GUID.create(params[p_idx].v_str)
	else:
		error_text_trans += "P1がGUIDでない"

	p_idx += 1

	# EXECはパラメータが整数1つしかないパターンもある
	
	# 完了を待つ
	if params[p_idx].v_int != 0:
		does_wait_finish = true
	else:
		does_wait_finish = false
	p_idx += 1

	# 開始を待つ
	if p_idx <= params.size() - 1:
		if params[p_idx].v_int != 0:
			does_wait_untill_begin = true
		else:
			does_wait_untill_begin = false
		p_idx += 1
	else:
		does_wait_untill_begin = false # 古い仕様では待たなかったので

	# 次のフレームから
	if p_idx <= params.size() - 1:
		if params[p_idx].v_int != 0:
			does_begin_at_next_frame = true
		else:
			does_begin_at_next_frame = false
		p_idx += 1
	else:
		does_begin_at_next_frame = true # 互換性のためなのでおそらくこっちがデフォルト


func reverse_into_paneru_params(
		params: Array[PaneruParam],
		) -> void:

	# GUID
	if true:
		PaneruParam.add_guid_to_params(params, guid)

	# 完了を待つ
	if does_wait_finish == true:
		PaneruParam.add_int_to_params(params, 1)
	else:
		PaneruParam.add_int_to_params(params, 0)

	# 開始を待つ
	if does_wait_untill_begin == true:
		PaneruParam.add_int_to_params(params, 1)
	else:
		PaneruParam.add_int_to_params(params, 0)

	# 次のフレームから
	if does_begin_at_next_frame == true:
		PaneruParam.add_int_to_params(params, 1)
	else:
		PaneruParam.add_int_to_params(params, 0)


func to_edit_lines(_last_begin: Komando.Type) -> String:
	var text: String = ""
	text += "call"
	text += " "
	if guid != null:
		text += guid.to_text()

	text += " "

	if does_wait_finish == true:
		text += "<<完了待つ>>"
	else:
		text += "<<完了待たず>>"

	text += " "

	if does_wait_untill_begin == true:
		text += "<<開始待つ>>"
	else:
		text += "<<開始待たず>>"

	text += " "

	if does_begin_at_next_frame == true:
		text += "<<次フレーム>>"
	else:
		text += "<<現フレーム>>"

	return text


func from_edit_lines(dst_error_text: Array[String], edit_lines: Array[TIPEditLine], line_idx: int) -> int:

#	"call" guid opt( "<<完了待つ>>" "<<完了待たず>>" .... )

	var word: String = ""
	var edit_line: TIPEditLine = null
	edit_line = edit_lines[line_idx]

	word = edit_line.try_get_next_word()
	if word != "call":
		dst_error_text.append("callを期待したがcallではない。: " + word)
		return -1

	word = edit_line.try_get_next_word()
	if word == "":
		dst_error_text.append("callの後でguid無しに終わっている。: " + word)
		return -1
	guid = GUID.try_parse_text(word)
	if guid == null:
		dst_error_text.append("callの後がguidでない。: " + word)
		return -1
	
	for i in range(0, 99):
		word = edit_line.try_get_next_word()
		if word == "":
			break
		if word == "<<完了待つ>>":
			does_wait_finish = true
		elif word == "<<完了待たず>>":
			does_wait_finish = false
		elif word == "<<開始待つ>>":
			does_wait_untill_begin = true
		elif word == "<<開始待たず>>":
			does_wait_untill_begin = false
		elif word == "<<次フレーム>>":
			does_begin_at_next_frame = true
		elif word == "<<現フレーム>>":
			does_begin_at_next_frame = false
		else:
			# エラー
			dst_error_text.append("callの後に不明なワード: " + word)
			pass

	line_idx += 1

	return line_idx
