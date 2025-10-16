class_name TIP_CHOICES
extends TIP

var branch_count: int = -1
var has_cancel_branch: bool = false
var item_params: Array[PickItemParam] = []
var display_loc: int = -1
var cancel_idx: int = -1
var initial_idx: int = -1


func transcript(
		params: Array[PaneruParam],
		) -> void:

	var p_idx: int = 0

	block_type = TIP.BlockType.BEGIN

	# 分岐の数（項目数＋キャンセル専用分岐）
	branch_count = params[p_idx].v_int
	p_idx += 1

	for i in range(0, branch_count):
		item_params.append(PickItemParam.new())

	# 表示テキスト（キャンセル専用分岐は架空の項目として扱われる）
	for i in range(0, branch_count):
		var item_text: String = params[p_idx].v_str
		item_params[i].text = item_text
		if item_text == "%%WhenCancel%%":
			has_cancel_branch = true
		p_idx += 1
	
	# 項目数は、キャンセル専用分岐があると1つ減る
	var item_count: int = branch_count
	if has_cancel_branch == true:
		item_count -= 1

	# 表示位置
	display_loc = params[p_idx].v_int
	p_idx += 1

	# 表示条件
	for i in range(0, item_count):
		if params[p_idx].param_type == PaneruParam.Type.JOKEN_ARG:
			item_params[i].disp_jokens = params[p_idx].v_jokens
			p_idx += 1
		else:
			# 条件が無い場合、空の「変数」となっている
			p_idx += 1

	# キャンセル時の項目（1起算、負でキャンセル無効、0で専用分岐）
	cancel_idx = params[p_idx].v_int
	p_idx += 1

	# 初期カーソル位置（1起算）
	initial_idx = params[p_idx].v_int
	p_idx += 1

	# 有効条件
	for i in range(0, item_count):
		if params[p_idx].param_type == PaneruParam.Type.JOKEN_ARG:
			item_params[i].enable_jokens = params[p_idx].v_jokens
			p_idx += 1
		else:
			# 条件が無い場合、空の「変数」となっている
			p_idx += 1


func to_edit_lines(_last_begin: Komando.Type) -> String:
	var text: String = ""

	text += "pick"
	text += "\t"

	text += "\n"

	if display_loc == 0:
		text += "<<左上>>"
	elif display_loc == 1:
		text += "<<上>>"
	elif display_loc == 2:
		text += "<<右上>>"
	elif display_loc == 3:
		text += "<<左>>"
	elif display_loc == 4:
		text += "<<中央>>"
	elif display_loc == 5:
		text += "<<右>>"
	elif display_loc == 6:
		text += "<<左下>>"
	elif display_loc == 7:
		text += "<<下>>"
	elif display_loc == 8:
		text += "<<右下>>"
	else:
		text += "<<表示位置不明>>"
	text += "\t"

	text += "\n"

	for i in range(0, branch_count):

		var item_text: String = item_params[i].text
		if item_text == "%%WhenCancel%%":
			text += "<<キャンセル専用分岐>>"
		else:
			text += item_text
		if initial_idx == i + 1:
			text += "\t"
			text += "<<初期位置>>"
		if cancel_idx == i + 1:
			text += "\t"
			text += "<<キャンセル時>>"
		text += "\n"

		for n in range(0, 2):

			var count: int = 0
			if n == 0:
				count = item_params[i].disp_jokens.size()
			if n == 1:
				count = item_params[i].enable_jokens.size()

			for k in range(0, count):
				
				var joken: Joken = item_params[i].disp_jokens[k]
				if n == 1:
					joken = item_params[i].enable_jokens[k]
				
				text += "\t"
				if n == 0:
					text += "<<表示条件>>"
				if n == 1:
					text += "<<有効条件>>"
				text += " "

				text += joken.ref_name

				if joken.joken_type == Joken.Type.COND_TYPE_VARIABLE:
					pass
				if (
						joken.joken_type == Joken.Type.COND_TYPE_ARRAY_VAR
						or
						joken.joken_type == Joken.Type.COND_TYPE_ARRAY_SW
						):
					text += "["
					if joken.pointa > 0:
						text += "%d" % joken.pointa
					else:
						if joken.rokaru_ref == true:
							text += "L:"
							text += joken.pointa_name
						else:
							text += joken.pointa_name
					text += "]"

				text += " "
				text += "=="
				text += " "

				if (
						joken.joken_type == Joken.Type.COND_TYPE_SWITCH
						or
						joken.joken_type == Joken.Type.COND_TYPE_ARRAY_SW
						):
					# C系の言語の慣習とは論理が逆なので注意。ゼロでオン。
					if joken.option == 0:
						text += "オン"
					else:
						text += "オフ"
				else:
					text += "%d" % joken.option
				text += "\n"


	return text
