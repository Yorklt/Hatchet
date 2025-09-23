class_name TIP_BOSSBATTLE
extends TIP

var monsuta_count: int = 0
var monsuta_guids: Array[String] = []
var monsuta_levels: Array[int] = []
var override_music: bool = false
var music_guid: String = ""

var disable_run_away: bool = false
var avoid_gemuoba: bool = false
var hide_begin_message: bool = false

var unknown_int_0: int = 0
var unknown_int_1: int = 0
var unknown_int_2: int = 0
var unknown_guid_0: String = ""
var unknown_int_3: int = 0
var unknown_int_4: int = 0
var unknown_int_5: int = 0


func transcript(
		params: Array[PaneruParam],
		) -> void:

	var p_idx: int = 0
	# var p_idx_next: Array[int] = []
	
	block_type = TIP.BlockType.BEGIN

	# 数
	monsuta_count = params[p_idx].v_int
	p_idx += 1

	# モンスターGUID
	for i in range(0, monsuta_count):
		var guid: String = params[p_idx].v_str
		monsuta_guids.append(guid)
		p_idx += 1

	# ゲームオーバーにしない
	if params[p_idx].v_int == 0:
		avoid_gemuoba = false
	else:
		avoid_gemuoba = true
	p_idx += 1

	# 逃げられない
	if params[p_idx].v_int == 0:
		disable_run_away = false
	else:
		disable_run_away = true
	p_idx += 1

	# 不明
	unknown_int_0 = params[p_idx].v_int
	p_idx += 1

	# 音楽
	music_guid = params[p_idx].v_str
	p_idx += 1

	# 音楽
	if music_guid == "00000000-0000-0000-0000-000000000000":
		override_music = false
	else:
		override_music = true

	# 不明
	unknown_guid_0 = params[p_idx].v_str
	p_idx += 1
	unknown_int_1 = params[p_idx].v_int
	p_idx += 1
	unknown_int_2 = params[p_idx].v_int
	p_idx += 1
	unknown_int_3 = params[p_idx].v_int
	p_idx += 1
	unknown_int_4 = params[p_idx].v_int
	p_idx += 1

	# モンスターレベル
	for i in range(0, monsuta_count):
		var level: int = params[p_idx].v_int
		monsuta_levels.append(level)
		p_idx += 1

	# 不明
	unknown_int_5 = params[p_idx].v_int
	p_idx += 1

	# 登場メッセージを出さない
	if params[p_idx].v_int == 0:
		hide_begin_message = false
	else:
		hide_begin_message = true
	p_idx += 1


func to_text(_last_begin: Komando.Type) -> String:
	var text: String = ""
	text += "combat"

	text += " "
	if disable_run_away == true:
		text += "<<逃走無し>>"
	else:
		text += "<<逃走あり>>"

	text += " "
	if avoid_gemuoba == true:
		text += "<<ゲームオーバー無し>>"
	else:
		text += "<<ゲームオーバーあり>>"

	text += " "
	if hide_begin_message == true:
		text += "<<登場メッセージ無し>>"
	else:
		text += "<<登場メッセージあり>>"

	text += " "
	if override_music == true:
		text += "<<音楽変更>>"
		text += " "
		text += music_guid

	for i in range(0, monsuta_count):
		text += "\n"
		text += monsuta_guids[i]
		text += " "
		text += "%d" % monsuta_levels[i]

	text += "\n"
	text += "<<不明なパラメータ>>"
	text += " "
	text += "%d" % unknown_int_0
	text += " "
	text += "%d" % unknown_int_1
	text += " "
	text += "%d" % unknown_int_2
	text += " "
	text += "%d" % unknown_int_3
	text += " "
	text += "%d" % unknown_int_4
	text += " "
	text += "%d" % unknown_int_5
	text += " "
	text += unknown_guid_0


	return text
