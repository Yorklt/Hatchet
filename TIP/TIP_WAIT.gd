class_name TIP_WAIT
extends TIP

var time: ValDesign = null

func transcript(
		params: Array[PaneruParam],
		) -> void:

	var p_idx: int = 0
	var p_idx_next: Array[int] = []

	# 時間
	time = ValDesign.parse_paneru_params(p_idx_next, params, p_idx)
	p_idx = p_idx_next[0]
	
	# WAIRは最後に謎の整数(1)がある。不明。
	p_idx += 1


func to_text(_last_begin: Komando.Type) -> String:
	var text: String = ""
	text += "wait"
	text += " "
	text += time.to_text()

	return text
