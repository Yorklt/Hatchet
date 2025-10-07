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
		error_text += "P1が文字列でない"


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


func from_edit_lines(dst_line_idx_next: Array[int], edit_lines: Array[TIPEditLine], line_idx: int) -> void:

	dst_line_idx_next.resize(1)
	dst_line_idx_next[0] = -1

#	"call" guid opt( "<<完了待つ>>" "<<完了待たず>>" .... )

	var word: String = ""

	var edit_line: TIPEditLine = null
	
	edit_line = edit_lines[line_idx]

	word = edit_line.try_get_next_word()
	if word != "//":
		error_text += "//を期待したが//ではない。: " + word
		return

	word = edit_line.try_get_next_word()
	if word == "":
		comment_text = word # こういうこともある
	else:
		comment_text = word

	# TODO コメントにスペースが入ってても問題ないようにする

	line_idx += 1
	dst_line_idx_next[0] = line_idx
