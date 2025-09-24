class_name TIP_ITEM
extends TIP

var item_guid: String = ""
var spec_angle: ValDesign = null
var loc_in_inventory: ValDesign = null
var change_type: int = -1
var sub_count: ValDesign = null


func transcript(
		params: Array[PaneruParam],
		) -> void:

	var p_idx: int = 0
	var p_idx_next: Array[int] = []

	if params[p_idx].param_type == PaneruParam.Type.GUID:
		# GUIDで指定
		item_guid = params[p_idx].v_str
		p_idx += 1
	else:
		# 何番目のアイテムか
		loc_in_inventory = ValDesign.parse_paneru_params(p_idx_next, params, p_idx)
		p_idx = p_idx_next[0]

	# 謎の整数0
	p_idx += 1

	# 変動数
	sub_count = ValDesign.parse_paneru_params(p_idx_next, params, p_idx)
	p_idx = p_idx_next[0]

	# 1で増加、2で減少
	change_type = params[p_idx].v_int


func to_text(_last_begin: Komando.Type) -> String:
	var text: String = ""
	text += "[[アイテム増減]]"

	if item_guid != "":
		text += " "
		text += item_guid
	else:
		text += " "
		text += "<<所持アイテム>>"
		text += " "
		text += loc_in_inventory.to_text()

	if change_type == 1:
		text += " "
		text += "<<増>>"
	elif change_type == 2:
		text += " "
		text += "<<減>>"
	else:
		text += " "
		text += "<<増減不明>>"

	text += " "
	text += sub_count.to_text()

	return text



	
