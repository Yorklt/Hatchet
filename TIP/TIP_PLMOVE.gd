class_name TIP_PLMOVE
extends TIP

var specify_const_loc: bool = false
var supotto: String = ""

var stay_mappu: bool = false
var mappu_id: ValDesign = null

var auto_y: bool = false
var pos_x: ValDesign = null
var pos_y: ValDesign = null
var pos_z: ValDesign = null

var direction: int = -1

func transcript(
		params: Array[PaneruParam],
		) -> void:

	var p_idx: int = 0
	var p_idx_next: Array[int] = []

	if params[p_idx].param_type == PaneruParam.Type.SUPOTTO:
		# 特定位置を指定
		specify_const_loc = true
		supotto = params[p_idx].v_str
	else:
		# 変数で指定
		specify_const_loc = false

		pos_x = ValDesign.parse_paneru_params(p_idx_next, params, p_idx)
		p_idx = p_idx_next[0]

		pos_z = ValDesign.parse_paneru_params(p_idx_next, params, p_idx)
		p_idx = p_idx_next[0]
	
	# 向き
	direction = params[p_idx].v_int
	p_idx += 1

	if specify_const_loc == false:

		# 今のマップ内で動く
		if params[p_idx].v_int == 0:
			stay_mappu = true
		else:
			stay_mappu = false
		p_idx += 1

		# マップID
		# stay_mappuがtrueでもファイルに存在する
		mappu_id = ValDesign.parse_paneru_params(p_idx_next, params, p_idx)
		p_idx = p_idx_next[0]

		# Yの指定
		auto_y = true
		if p_idx <= params.size() - 1:
			# パラメータがまだ続く場合、謎の整数(1)が存在する。
			# おそらく、Yを指定することを示している。
			auto_y = false
			p_idx += 1

			# Yの指定
			pos_y = ValDesign.parse_paneru_params(p_idx_next, params, p_idx)
			p_idx = p_idx_next[0]


func to_text(_last_begin: Komando.Type) -> String:
	var text: String = ""
	text += "[[PL移動]]"

	if specify_const_loc == true:
		text += " "
		text += supotto

	else:
		text += " "
		if stay_mappu == true:
			text += "<<現マップ>>"
		else:
			text += "<<指定マップ>>"
			text += " "
			text += mappu_id.to_text()
	
		text += " "
		text += "("
		text += " "
		text += pos_x.to_text()
		if auto_y == true:
			text += " "
			text += "<<自動Y>>"
		else:
			text += " "
			text += pos_y.to_text()
		text += " "
		text += pos_z.to_text()
		text += ")"

	text += " "
	if direction == 0:
		text += "<<向き維持>>"
	elif direction == 1:
		text += "<<上>>"
	elif direction == 2:
		text += "<<下>>"
	elif direction == 3:
		text += "<<左>>"
	elif direction == 4:
		text += "<<右>>"
	else:
		text += "<<??>>"

	return text
