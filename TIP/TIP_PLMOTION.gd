class_name TIP_PLMOTION
extends TIP

var preview_guid: GUID = null
var moshon_name: String = ""
var keep_until_finish: bool = false
var trans_time: ValDesign = null


func transcript(
		params: Array[PaneruParam],
		) -> void:

	var p_idx: int = 0
	var p_idx_next: Array[int] = []

	# 整数、GUID、整数、GUIDから始まる。
	# 最後のGUIDはGUI上でモーションを選ばせるときの、プレビューとなるスタンプで間違いないが、
	# 最初の3つのパラメータは用途が不明。パーティーメンバーの任意のキャラだけ動かせるように
	# しようとしていた名残かもしえない。

	# 3つ飛ばす
	p_idx += 1
	p_idx += 1
	p_idx += 1
	
	# 参照用スタンプ？
	preview_guid = GUID.create(params[p_idx].v_str)
	p_idx += 1
	
	# モーション名
	moshon_name = params[p_idx].v_str
	p_idx += 1

	# 完了までモーションを変えない
	if params[p_idx].v_int == 0:
		keep_until_finish = true
	else:
		keep_until_finish = false
	p_idx += 1

	# フェード時間がないこともある
	if p_idx <= params.size() - 1:
		# フェード時間
		trans_time = ValDesign.parse_paneru_params(p_idx_next, params, p_idx)
		p_idx = p_idx_next[0]
	else:
		# ひとまずGUI上のデフォルト値である0.2とする
		trans_time = ValDesign.new()
		trans_time.chokuchi = Chokuchi.new()
		trans_time.val_design_type = ValDesign.Type.LITERAL
		trans_time.chokuchi.c_type = Chokuchi.Type.FLOAT
		trans_time.chokuchi.v_float = 0.2


func to_edit_lines(_last_begin: Komando.Type) -> String:
	var text: String = ""
	text += "[[プレモー]]"

	text += " "
	text += moshon_name
	text += " "
	text += trans_time.to_text()
	
	if keep_until_finish == true:
		text += " "
		text += "<<完了まで変えない>>"

	if preview_guid != null:
		if preview_guid.v_str != "00000000-0000-0000-0000-000000000000":
			text += " "
			text += "<<参照スタンプ>>"
			text += preview_guid.to_text()

	return text



	
