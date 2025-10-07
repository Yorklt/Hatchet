class_name TIP_STRING_VARIABLE
extends TIP

enum StoreType
{
	OVERWRITE,
	FRONT,
	BACK,
}

var lhs_type: int = 0
var lhs_hensu: Hensu = null
var lhs_guid: GUID = null
var rhs_text: String = ""
var store_type: TIP_STRING_VARIABLE.StoreType = TIP_STRING_VARIABLE.StoreType.OVERWRITE

func transcript(
		params: Array[PaneruParam],
		) -> void:

	var p_idx: int = 0
	var p_idx_next: Array[int] = []

	if params[p_idx].param_type == PaneruParam.Type.INT:
		# 変数以外への代入
		lhs_type = -1
		p_idx += 1
	else:
		lhs_type = 0
		lhs_hensu = Hensu.parse_paneru_params(p_idx_next, params, p_idx)
		p_idx = p_idx_next[0]

	# 文字列
	rhs_text = params[p_idx].v_str
	p_idx += 1

	# 代入モード
	if params[p_idx].v_int == 0:
		store_type = TIP_STRING_VARIABLE.StoreType.OVERWRITE
	elif params[p_idx].v_int == 1:
		store_type = TIP_STRING_VARIABLE.StoreType.FRONT
	elif params[p_idx].v_int == 2:
		store_type = TIP_STRING_VARIABLE.StoreType.BACK
	else:
		# エラー
		pass
	p_idx += 1

	# 変数以外への代入
	if lhs_type != 0:
		lhs_guid = GUID.create(params[p_idx].v_str)
	p_idx += 1


func to_edit_lines(_last_begin: Komando.Type) -> String:
	var text: String = ""
	text += "[[文字列代入]]"

	if lhs_type == 0:
		text += " "
		text += lhs_hensu.to_text()
	else:
		text += " "
		text += "<<特殊>>"
		text += " "
		text += lhs_guid.to_text()

	if store_type == TIP_STRING_VARIABLE.StoreType.OVERWRITE:
		text += " "
		text += "<<上書き>>"
	elif store_type == TIP_STRING_VARIABLE.StoreType.FRONT:
		text += " "
		text += "<<先頭>>"
	elif store_type == TIP_STRING_VARIABLE.StoreType.BACK:
		text += " "
		text += "<<最後尾>>"

	text += "\n"
	text += rhs_text

	return text
