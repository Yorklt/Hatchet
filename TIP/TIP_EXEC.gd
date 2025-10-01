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
		error_text += "P1がGUIDでない"

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



func to_text(_last_begin: Komando.Type) -> String:
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

	return text + error_text


func parse_edit_lines(edit_lines: Array[TIPEditLine], line_idx: int) -> void:
	
#	"call" guid opt( "<<完了待つ>>" "<<完了待たず>>" .... )

	var word: String = ""

	var edit_line: TIPEditLine = null
	
	edit_line = edit_lines[line_idx]

	word = edit_line.try_get_next_word()
	if word != "call":
		return
	
	word = edit_line.try_get_next_word()
	if word == "":
		return
	guid = GUID.try_parse_text(word)
	if guid == null:
		return
	
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
			pass
