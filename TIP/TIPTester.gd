class_name TIPTester
extends Node


func _init() -> void:
	var edit_line: TIPEditLine = TIPEditLine.new()
	var is_quoted: Array[bool] = []
	var text: String = ""

	edit_line.line = "\t\t call X[A] =   13.0f <<Opt>> \r\n"
	edit_line.loc = 0
	
	print(edit_line.line)
	while true:
		text = edit_line.try_get_next_word(is_quoted)
		if text == "":
			break
		print(text)
	print("END")

	edit_line.line = " \t\t  a  \"ABC DEF G\"    \"\"  \"ABC \\\"DEF G\""
	edit_line.loc = 0
	
	print(edit_line.line)
	while true:
		text = edit_line.try_get_next_word(is_quoted)
		if text == "":
			break
		print(text)
	print("END")

	edit_line.line = "\t\tcall 12345678-1234-1234-1234-1234567890ab <<完了待つ>> <<開始待たず>> <<現フレーム>>"
	edit_line.loc = 0
	var tip: TIP_EXEC = TIP_EXEC.new()
	tip.parse_edit_line(edit_line)
	print(tip.to_text(Komando.Type.INVALID))
