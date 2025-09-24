class_name TIP_MOTION
extends TIP

var preview_guid: String = ""
var moshon_name: String = ""
var trans_time: ValDesign = null


func transcript(
		params: Array[PaneruParam],
		) -> void:

	var p_idx: int = 0
	var p_idx_next: Array[int] = []
	
	# 参照用スタンプ？
	preview_guid = params[p_idx].v_str
	p_idx += 1
	
	# モーション名
	moshon_name = params[p_idx].v_str
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


func to_text(_last_begin: Komando.Type) -> String:
	var text: String = ""
	text += "[[イベモー]]"

	text += " "
	text += moshon_name
	text += " "
	text += trans_time.to_text()

	if preview_guid != "00000000-0000-0000-0000-000000000000":
		text += " "
		text += "<<参照スタンプ>>"
		text += preview_guid

	return text



	
