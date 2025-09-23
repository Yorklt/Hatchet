class_name TIP_LOOP
extends TIP

var count: ValDesign = null
var counter: Hensu = null
var init_val: ValDesign = null

func transcript(
		params: Array[PaneruParam],
		) -> void:

	var p_idx: int = 0
	var p_idx_next: Array[int] = []
	
	block_type = TIP.BlockType.BEGIN

	if params[p_idx].v_int == 0:
		# 無限
		p_idx += 1
	else:
		# 回数あり
		p_idx += 1
		
		# LOOPは、回数だけ、カウンターあり、初期値もあり、の3パターンの形式が存在する。
		
		count = ValDesign.parse_paneru_params(p_idx_next, params, p_idx)
		p_idx = p_idx_next[0]
		
		if p_idx <= params.size() - 1:

			counter = Hensu.parse_paneru_params(p_idx_next, params, p_idx)
			p_idx = p_idx_next[0]

			if p_idx <= params.size() - 1:

				init_val = ValDesign.parse_paneru_params(p_idx_next, params, p_idx)
				p_idx = p_idx_next[0]


func to_text(_last_begin: Komando.Type) -> String:
	var text: String = ""
	text += "loop"
	text += " "

	if counter != null:
		text += " "
		text += counter.to_text()
	if init_val != null:
		text += " "
		text += "from"
		text += " "
		text += init_val.to_text()
	if count != null:
		text += " "
		text += "times"
		text += " "
		text += count.to_text()
	return text
