class_name TIP_BOSSBATTLE
extends TIP

var monsuta_count: int = 0
var monsuta_guids: Array[String] = []
var monsuta_levels: Array[int] = []
var monsuta_locs_x: Array[int] = []
var monsuta_locs_z: Array[int] = []
var override_music: bool = false
var music_guid: String = ""

var disable_run_away: bool = false
var avoid_gemuoba: bool = false
var hide_begin_message: bool = false

var mappu_guid: String = ""

var unknown_int_0: int = -1
var unknown_int_100x: Dictionary[int, Array] = {}


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

	# 配置調整のマップ、おそらく
	mappu_guid = params[p_idx].v_str
	p_idx += 1

	# 不明な領域
	# この後は整数だけが続く。1000～1006の後にいくつか数字が続く
	# 100zと1002と1006だけは意味がわかっている
	var i100x: int  = -1
	var loc_x_z: int = 0
	for i in range(0, params.size()):
		if p_idx > params.size() - 1:
			break
		var v: int = params[p_idx].v_int
		if v >= 1000:
			i100x = v
			if unknown_int_100x.has(i100x) == false:
				unknown_int_100x.set(i100x, [])
		else:
			unknown_int_100x[i100x].append(v)

			if i100x == 1001:
				# モンスターLOC
				if loc_x_z == 0:
					monsuta_locs_x.append(v)
					loc_x_z = 1
				else:
					monsuta_locs_z.append(v)
					loc_x_z = 0
			if i100x == 1002:
				# モンスターレベル
				monsuta_levels.append(v)
			if i100x == 1006:
				# 登場メッセージを出さない
				if v == 0:
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
	text += "\n"

	for i in range(0, monsuta_count):
		text += monsuta_guids[i]
		text += " "
		text += "<<レベル>>"
		text += " "
		text += "%d" % monsuta_levels[i]
		if i <= monsuta_locs_x.size() - 1:
			text += " "
			text += "<<X>>"
			text += "%d" % monsuta_locs_x[i]
		if i <= monsuta_locs_z.size() - 1:
			text += " "
			text += "<<Z>>"
			text += "%d" % monsuta_locs_z[i]
		text += " "
		text += " "
		text += "\n"

	text += "<<マップ>>"
	text += " "
	text += mappu_guid

	for n in range(0, 7):
		var i100x: int = 1000 + n
		if i100x == 1001 or i100x == 1002 or i100x == 1006: # 意味が分かってるので飛ばす
			continue
		if unknown_int_100x.has(i100x) == true:
			text += "\n"
			text += "<<100xパラメータ>>"
			text += "%d" % i100x
			text += " "
			for i in range(0, unknown_int_100x[i100x].size()):
				text += " "
				text += "%d" % unknown_int_100x[i100x][i]
			text += " "
			text += " "
			text += " "

	return text
