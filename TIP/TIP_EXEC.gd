class_name TIP_EXEC
extends TIP

var guid: String = ""
var does_wait_finish: bool = false
var does_wait_untill_begin: bool = false
var does_begin_at_next_frame: bool = false

func transcript(
		params: Array[PaneruParam],
		) -> void:

	var p_idx: int = 0

	# テキスト
	if params[p_idx].param_type == PaneruParam.Type.GUID:
		guid = params[p_idx].v_str
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
	text += guid

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
