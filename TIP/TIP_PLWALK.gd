class_name TIP_PLWALK
extends TIP

var dir_type: int = -1
var spec_angle: ValDesign = null
var force_cardinal: bool = false
var move_length: ValDesign = null

var keep_dirction: bool = false
var go_through_ibento: bool = false
var ignore_height_gap: bool = false
var finish_on_halt: bool = false
var keep_current_moshon: bool = false
var move_smoothly: bool = false



func transcript(
		params: Array[PaneruParam],
		) -> void:

	var p_idx: int = 0
	var p_idx_next: Array[int] = []
	
	# 方向タイプ
	dir_type = params[p_idx].v_int
	p_idx += 1

	# 歩数
	move_length = ValDesign.parse_paneru_params(p_idx_next, params, p_idx)
	p_idx = p_idx_next[0]

	# 向きを固定
	if params[p_idx].v_int == 0:
		keep_dirction = false
	else:
		keep_dirction = true
	p_idx += 1

	# 移動できなかったら中断
	if params[p_idx].v_int == 0:
		finish_on_halt = false
	else:
		finish_on_halt = true
	p_idx += 1

	# イベントをすり抜ける
	if params[p_idx].v_int == 0:
		go_through_ibento = false
	else:
		go_through_ibento = true
	p_idx += 1

	# 段差を超える
	if params[p_idx].v_int == 0:
		ignore_height_gap = false
	else:
		ignore_height_gap = true
	p_idx += 1

	# モーションを変更しない
	if params[p_idx].v_int == 0:
		keep_current_moshon = false
	else:
		keep_current_moshon = true
	p_idx += 1

	# 指定角度（タイプに関わらず存在するフィールド）
	spec_angle = ValDesign.parse_paneru_params(p_idx_next, params, p_idx)
	p_idx = p_idx_next[0]

	# 不明な整数値0
	p_idx += 1

	# なめらか
	if params[p_idx].v_int == 0:
		move_smoothly = false
	else:
		move_smoothly = true
	p_idx += 1

	# 四方に丸める
	if params[p_idx].v_int == 0:
		force_cardinal = false
	else:
		force_cardinal = true
	p_idx += 1


func to_edit_lines(_last_begin: Komando.Type) -> String:
	var text: String = ""
	text += "[[プレ歩行]]"

	text += " "
	if dir_type == 0:
		text += "<<上>>"
	if dir_type == 1:
		text += "<<下>>"
	if dir_type == 2:
		text += "<<左>>"
	if dir_type == 3:
		text += "<<右>>"
	if dir_type == 5:
		text += "<<近づく>>"
	if dir_type == 6:
		text += "<<遠ざかる>>"
	if dir_type == 7:
		text += "<<明後日>>"
	if dir_type == 8:
		text += "<<前進>>"
	if dir_type == 10:
		text += "<<指定方向>>"
		text += " "
		text += spec_angle.to_edit_text()
	
	if force_cardinal == true:
		text += " "
		text += "<<四方のみ>>"
	
	text += " "
	text += move_length.to_edit_text()

	if keep_dirction == true:
		text += " "
		text += "<<向き固定>>"
	if go_through_ibento == true:
		text += " "
		text += "<<イベ透過>>"
	if ignore_height_gap == true:
		text += " "
		text += "<<段差超え>>"
	if finish_on_halt == true:
		text += " "
		text += "<<移動不可で中断>>"
	if keep_current_moshon == true:
		text += " "
		text += "<<モーション固定>>"
	if move_smoothly == true:
		text += " "
		text += "<<なめらか>>"

	return text



	
