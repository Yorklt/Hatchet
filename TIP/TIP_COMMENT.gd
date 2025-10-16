class_name TIP_COMMENT
extends TIP

var comment_text: String = ""


func transcript(
		params: Array[PaneruParam],
		) -> void:

	var p_idx: int = 0

	# テキスト
	if params[p_idx].param_type == PaneruParam.Type.STRING:
		comment_text = params[p_idx].v_str
	else:
		error_text += "P1が文字列でない" + " "


func reverse_into_paneru_params(
		params: Array[PaneruParam],
		) -> void:

	# コメント
	if true:
		PaneruParam.add_str_to_params(params, comment_text)


func to_edit_lines(_last_begin: Komando.Type) -> String:
	var text: String = ""
	text += "//"
	text += " "
	text += comment_text
	return text + error_text


func from_edit_lines(edit_lines: Array[TIPEditLine], line_idx: int) -> int:

#	"call" guid opt( "<<完了待つ>>" "<<完了待たず>>" .... )

	var word: String = ""
	var edit_line: TIPEditLine = null	
	edit_line = edit_lines[line_idx]

	word = edit_line.try_get_next_word()
	if word != "//":
		error_text += "//を期待したが//ではない。: " + word + " "
		return -1

	# 行の残りを全部コメントとする
	var length: int = edit_line.line.length() - 3
	if length > 0:
		comment_text = edit_line.line.right(length)
	else:
		comment_text = "" # こういうこともある

	line_idx += 1
	return line_idx
