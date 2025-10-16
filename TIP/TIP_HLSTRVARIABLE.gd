class_name TIP_HLSTRVARIABLE
extends TIP

enum StoreType
{
	OVERWRITE,
	FRONT,
	BACK,
}

var lhs_hensu: Hensu = null
var rhs_type: int = -1
var rhs_hensu: Hensu = null
var rhs_params: Array[PaneruParam] = []
var store_type: TIP_HLSTRVARIABLE.StoreType = TIP_HLSTRVARIABLE.StoreType.OVERWRITE


func transcript(
		params: Array[PaneruParam],
		) -> void:

	var p_idx: int = 0
	var p_idx_next: Array[int] = []

	# 左辺
	lhs_hensu = Hensu.parse_paneru_params(p_idx_next, params, p_idx)
	p_idx = p_idx_next[0]

	# 右辺の種類
	rhs_type = params[p_idx].v_int
	p_idx += 1

	# 右辺
	if rhs_type == 0:
		# 変数
		rhs_hensu = Hensu.parse_paneru_params(p_idx_next, params, p_idx)
		p_idx = p_idx_next[0]
	else:
		# それ以外
		# ひとまず格納する
		for i in range(0, params.size()):
			if p_idx > params.size() - 1 - 1: # 最後の1個は代入モード
				break
			rhs_params.append(params[p_idx])
			p_idx += 1

	# 代入モード
	if params[p_idx].v_int == 0:
		store_type = TIP_HLSTRVARIABLE.StoreType.OVERWRITE
	elif params[p_idx].v_int == 1:
		store_type = TIP_HLSTRVARIABLE.StoreType.FRONT
	elif params[p_idx].v_int == 2:
		store_type = TIP_HLSTRVARIABLE.StoreType.BACK
	else:
		# エラー
		pass
	p_idx += 1


func to_edit_lines(_last_begin: Komando.Type) -> String:
	var text: String = ""
	text += "[[文字列操作]]"

	text += " "
	text += lhs_hensu.to_edit_text()

	if store_type == TIP_HLSTRVARIABLE.StoreType.OVERWRITE:
		text += " "
		text += "<<上書き>>"
	elif store_type == TIP_HLSTRVARIABLE.StoreType.FRONT:
		text += " "
		text += "<<先頭>>"
	elif store_type == TIP_HLSTRVARIABLE.StoreType.BACK:
		text += " "
		text += "<<最後尾>>"

	if rhs_type == 0:
		# 変数
		text += " "
		text += rhs_hensu.to_edit_text()
	else:
		# その他の右辺は面倒見切れない
		text += " "
		text += "<<特殊>>"
		text += " "
		text += "%d" % rhs_type
		for i in range(0, rhs_params.size()):
			text += " "
			text += rhs_params[i].to_edit_text()

	return text
