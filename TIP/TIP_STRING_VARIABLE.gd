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
		text += lhs_hensu.to_edit_text()
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

	# 複数行に分ける
	var lines: PackedStringArray = rhs_text.split("\\n", true)
	for k in range(0, lines.size()):
		text += "\"" + lines[k] + "\""
		text += "\n"

	return text


func from_edit_lines(edit_lines: Array[TIPEditLine], line_idx: int) -> int:

	# [[文字列代入]] L:お名前 <<上書き>>
	# [[文字列代入]] A:リスト[L:i] <<最後尾>>
	# [[文字列代入]] <<特殊>> xxxxxxxx <<上書き>>

	var word: String = ""
	var edit_line: TIPEditLine = null
	edit_line = edit_lines[line_idx]

	if true:
		word = edit_line.try_get_next_word()
		if word == "<<特殊>>":
			lhs_type = -1
			word = edit_line.try_get_next_word()
			lhs_guid = GUID.try_parse_text(word)
			if lhs_guid == null:
				error_text += "左辺が特殊タイプだけどGUIDが不明。: " + word
				return -1
			pass
		else:
			lhs_type = 0
			var hensu: Hensu = Hensu.try_parse_edit_text(word)
			if hensu == null:
				error_text += "左辺が変数ではない。: " + word + " " + Hensu.parse_fail_msg + " "
				return -1
			lhs_hensu = hensu

	if true:
		word = edit_line.try_get_next_word()
		if word == "<<上書き>>":
			store_type = TIP_STRING_VARIABLE.StoreType.OVERWRITE
		elif word == "<<先頭>>":
			store_type = TIP_STRING_VARIABLE.StoreType.FRONT
		elif word == "<<最後尾>>":
			store_type = TIP_STRING_VARIABLE.StoreType.BACK
		else:
			error_text += "代入タイプが不明。: " + word
			return -1

	line_idx += 1

	return line_idx
