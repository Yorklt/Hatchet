class_name Paneru
extends RefCounted

var komando_text: String = "" # デバッグ用途
var komando_type: Komando.Type
var params: Array[PaneruParam] = []
var tip: TIP = null

func to_text(last_begin: Komando.Type) -> String:
	var text: String = ""
	if tip == null:
		text += komando_text
		text += " "
		for i in range(0, params.size()):
			text += " "
			text += params[i].to_text()
	else:
		text = tip.to_text(last_begin)
		if tip.error_text != "":
			text = " " + tip.error_text
	return text


static func parse_edit_lines(edit_lines: Array[TIPEditLine], line_idx: int) -> Paneru:

	var word: String = ""

	var edit_line: TIPEditLine = null
	
	edit_line = edit_lines[line_idx]

	word = edit_line.try_get_next_word()
	if word != "":
		var komando: Komando.Type = TIPResolver.try_solve_initial_word(word)
		if komando != Komando.Type.INVALID:
			var paneru: Paneru = Paneru.new()
			paneru.tip = TIPResolver.try_create_tip_by_komando(komando)
			if paneru.tip != null:
				#tip_message.parse_edit_lines(edit_lines, line_idx)
				pass
			return paneru

	return null
