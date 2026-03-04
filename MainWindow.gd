class_name MainWindow
extends Control

var _filepath_line_edit: LineEdit = null
var _file_dialog_button: Button = null
var _load_button: Button = null
var _save_button: Button = null
var _shiito_list: ItemList = null
var _content_edit: TextEdit = null
var _reverse_button: Button = null
var _auto_reverse_check_button: CheckButton = null
var _ibento_file_edit: TextEdit = null
var _raw_text_edit: TextEdit = null
var _error_count_label: Label = null
var _file_dialog: FileDialog = null

var _ibento: Ibento = null

var _edit_shiito_idx: int = -1
var _does_auto_reverse: bool = true
var _is_content_edited: bool = false
var _content_edit_time: float = 0.0


func _ready() -> void:

	# シーン埋め込みのノード取得
	_filepath_line_edit = $FilepathEdit as LineEdit
	_file_dialog_button = $FileDialogButton as Button
	_load_button = $LoadButton as Button
	_save_button = $HSplitContainer/RightArea/SaveButton as Button
	_shiito_list = $ShiitoList as ItemList
	_content_edit = $HSplitContainer/ContentEdit as TextEdit
	_reverse_button = $HSplitContainer/RightArea/ReverseButton as Button
	_auto_reverse_check_button = $HSplitContainer/RightArea/AutoReverseCheckButton as CheckButton
	_ibento_file_edit = $HSplitContainer/RightArea/HSplitContainer/RightBottomLeftArea/IbentoFileText as TextEdit
	_raw_text_edit = $HSplitContainer/RightArea/HSplitContainer/RightBottomRightArea/OriginalText as TextEdit
	_error_count_label = $HSplitContainer/RightArea/ErrorCount as Label

	# ファイルパスの入力欄
	_filepath_line_edit.text_changed.connect(_on_filepath_line_edit_text_changed)

	# ファイル選択ダイアログを開くボタン
	_file_dialog_button.pressed.connect(_on_file_dialog_button_pressed)

	# ロードボタン
	_load_button.disabled = true
	_load_button.pressed.connect(_on_load_button_pressed)

	# セーブボタン
	_save_button.disabled = true
	_save_button.pressed.connect(_on_save_button_pressed)

	# シートリスト
	_shiito_list.item_selected.connect(_on_shiito_list_selected)

	# 内容エディタ
	_content_edit.editable = false
	_content_edit.lines_edited_from.connect(_on_content_edit_lines_edited_from)

	# 変換ボタン
	_reverse_button.pressed.connect(_on_reverse_button_pressed)

	# 自動変換チェックボックス
	_does_auto_reverse = true
	_auto_reverse_check_button.button_pressed = _does_auto_reverse
	_auto_reverse_check_button.toggled.connect(_on_auto_reverse_check_button_toggled)
	
	# 変換後のテキスト
	_ibento_file_edit.caret_changed.connect(_on_ibento_file_edit_caret_changed)

	# 内容エディタハイライト
	var highlighter: CodeHighlighter = CodeHighlighter.new()
	highlighter.number_color = Color.WHITE
	highlighter.symbol_color = Color.WHITE
	highlighter.function_color = Color.WHITE
	highlighter.add_keyword_color("if", Color.DODGER_BLUE)
	highlighter.add_keyword_color("else", Color.DODGER_BLUE)
	highlighter.add_keyword_color("endif", Color.DODGER_BLUE)
	highlighter.add_keyword_color("loop", Color.DODGER_BLUE)
	highlighter.add_keyword_color("for", Color.DODGER_BLUE)
	highlighter.add_keyword_color("from", Color.DODGER_BLUE)
	highlighter.add_keyword_color("times", Color.DODGER_BLUE)
	highlighter.add_keyword_color("endloop", Color.DODGER_BLUE)
	highlighter.add_keyword_color("break", Color.DODGER_BLUE)
	highlighter.add_keyword_color("return", Color.DEEP_SKY_BLUE)
	highlighter.add_keyword_color("label", Color.DEEP_SKY_BLUE)
	highlighter.add_keyword_color("goto", Color.DEEP_SKY_BLUE)
	highlighter.add_keyword_color("call", Color.DODGER_BLUE)

	highlighter.add_keyword_color("msg", Color.DARK_SALMON)
	highlighter.add_keyword_color("pick", Color.DARK_SALMON)
	highlighter.add_keyword_color("picked", Color.DARK_SALMON)
	highlighter.add_keyword_color("endpick", Color.DARK_SALMON)
	highlighter.add_keyword_color("wait", Color.DARK_SALMON)
	highlighter.add_keyword_color("combat", Color.DARK_SALMON)
	highlighter.add_keyword_color("ranaway", Color.DARK_SALMON)
	highlighter.add_keyword_color("defeated", Color.DARK_SALMON)
	highlighter.add_keyword_color("endcombat", Color.DARK_SALMON)

	highlighter.add_keyword_color("exclude", Color.WEB_GRAY)
	highlighter.add_keyword_color("endex", Color.WEB_GRAY)

	highlighter.add_color_region("//", "", Color.WEB_GRAY, true)
	highlighter.add_color_region("[[", "]]", Color.AQUAMARINE, false)
	highlighter.add_color_region("<<", ">>", Color.DARK_KHAKI, false)
	highlighter.add_color_region("\"", "\"", Color(0.9, 0.8, 0.7), false)

	_content_edit.syntax_highlighter = highlighter

	var highlighter_file: CodeHighlighter = CodeHighlighter.new()
	highlighter_file.number_color = Color.WHITE
	highlighter_file.symbol_color = Color.WHITE
	highlighter_file.function_color = Color.WHITE
	highlighter_file.add_color_region("{{", "}}", Color.BURLYWOOD, false)
	_ibento_file_edit.syntax_highlighter = highlighter_file


func _process(delta: float) -> void:
	_content_edit_time = clamp(_content_edit_time - delta, 0.0, 99.0)
	if _does_auto_reverse == true and _is_content_edited == true:
		if _content_edit_time <= 0.0:
			_is_content_edited = false
			_content_edit_time = 1.0
			_show_ibento_file_text()


func _on_filepath_line_edit_text_changed(_text: String) -> void:
	_update_load_save_buttons()


func _on_file_dialog_button_pressed() -> void:

	if _file_dialog == null:

		var file_dialog: FileDialog = FileDialog.new()
		_file_dialog = file_dialog
		
		file_dialog.access = FileDialog.ACCESS_FILESYSTEM
		file_dialog.title = "エクスポートしたイベントファイルを選んでください"
		file_dialog.mode_overrides_title = false
		file_dialog.file_mode = FileDialog.FILE_MODE_OPEN_FILE
		file_dialog.filters = PackedStringArray(["*.txt ; イベントファイル"])

		file_dialog.display_mode = FileDialog.DISPLAY_LIST
		file_dialog.ok_button_text = "選択"
		file_dialog.cancel_button_text = "キャンセル"

		file_dialog.add_theme_color_override("file_icon_color", Color(0.6, 1.0, 1.0, 1.0))
		file_dialog.add_theme_color_override("folder_icon_color", Color(1.0, 0.9, 0.8, 1.0))
		#file_dialog.add_theme_color_override()
		
		file_dialog.size.x = 880
		file_dialog.size.y = 700
		file_dialog.position.x = int(0.5 * float(size.x) - 0.5 * float(file_dialog.size.x))
		file_dialog.position.y = int(0.5 * float(size.y) - 0.5 * float(file_dialog.size.y))
		# ウィンドウが小さすぎる時にバツボタンが押せなくなるので
		if file_dialog.position.y < 32:
			file_dialog.position.y = 32

		file_dialog.file_selected.connect(_on_file_dialog_file_selected)
		file_dialog.canceled.connect(_on_file_dialog_canceled)

		file_dialog.visible = true

		get_tree().root.add_child(file_dialog)


func _on_file_dialog_file_selected(path: String) -> void:

	_file_dialog.queue_free()
	_file_dialog = null

	_filepath_line_edit.text = path
	_update_load_save_buttons()


func _on_file_dialog_canceled() -> void:

	_file_dialog.queue_free()
	_file_dialog = null



func _on_load_button_pressed() -> void:
	
	var path: String = _filepath_line_edit.text

	if FileAccess.file_exists(path) == false:
		return

	_ibento = Ibento.new()
	IbentoFileReader.read(_ibento, path)

	for shiito_idx in range(0, _ibento.shiitos.size()):
		TIPResolver.transcript_panels(_ibento.shiitos[shiito_idx].panerus)

	_shiito_list.clear()
	for i in range(0, _ibento.shiitos.size()):
		_shiito_list.add_item(_ibento.shiitos[i].shiito_name)

	_edit_shiito_idx = 0
	_show_paneru_text()
	_show_raw_text()


func _on_save_button_pressed() -> void:

	if _ibento == null:
		return

	var path: String = _filepath_line_edit.text
	var extension: String = path.get_extension()
	path = path.left(0 - extension.length() - 1) # 拡張子とピリオドを取り除く
	path += "_mod"
	path += "." + extension
	IbentoFileWriter.write(_ibento, path)


func _on_shiito_list_selected(index: int) -> void:
	_edit_shiito_idx = index
	_show_paneru_text()
	_show_raw_text()


func _on_content_edit_lines_edited_from(_from_line: int, _to_line: int) -> void:
	_is_content_edited = true


func _on_ibento_file_edit_caret_changed() -> void:

	if _ibento == null:
		return
	if _edit_shiito_idx < 0 or _edit_shiito_idx > _ibento.shiitos.size() - 1:
		return
#
	#var line_at: int = _ibento_file_edit.get_caret_line(0)
#
	#var paneru_idx: int = 0
	#for i in range(0, _ibento.shiitos[_edit_shiito_idx].panerus.size()):
		#if _ibento.shiitos[_edit_shiito_idx].panerus[i].edit_line_idx == line_at:
			#paneru_idx = 0


func _update_load_save_buttons() -> void:

	var path: String = _filepath_line_edit.text

	# ファイルが存在すればボタン有効
	if path != "":
		if FileAccess.file_exists(path) == true:
			_load_button.disabled = false
			_load_button.text = "読み込み"
			_save_button.disabled = false
			_save_button.text = "上書き"
		else:
			_load_button.disabled = true
			_load_button.text = "存在しません"
			_save_button.disabled = false
			_save_button.text = "新規保存"
	else:
		_load_button.disabled = true
		_load_button.text = ""
		_save_button.disabled = true
		_save_button.text = ""


func _show_paneru_text() -> void:
	if _ibento == null:
		return
	if _edit_shiito_idx < 0 or _edit_shiito_idx > _ibento.shiitos.size() - 1:
		return

	var dst_text: Array[String] = []
	TIPTWriter.panerus_to_tip_text(dst_text, _ibento.shiitos[_edit_shiito_idx].panerus)

	_content_edit.text = dst_text[0]
	_content_edit.editable = true
	#_content_edit.scroll_vertical = float(_content_edit.get_last_unhidden_line())


func _on_reverse_button_pressed() -> void:

	_show_ibento_file_text()


func _on_auto_reverse_check_button_toggled(toggled_on: bool) -> void:
	_does_auto_reverse = toggled_on



func _show_ibento_file_text() -> void:

	if _ibento == null:
		return
	if _edit_shiito_idx < 0 or _edit_shiito_idx > _ibento.shiitos.size() - 1:
		return

	var file_text: String = ""

	if true:
		var text: String = ""
		text = _content_edit.text
		
		var panerus: Array[Paneru] = []
		TIPTReader.tip_text_to_panerus(panerus, text)
		_ibento.shiitos[_edit_shiito_idx].panerus = panerus
		
		var error_count: int = 0
		for i in range(0, panerus.size()):
			if panerus[i].tipt_error != "":
				error_count += 1
		if error_count > 0:
			_error_count_label.text = "エラーあり（" + str(error_count) + "個）"
			_error_count_label.add_theme_color_override("font_color", Color.BURLYWOOD)
		else:
			_error_count_label.text = ""
			_error_count_label.add_theme_color_override("font_color", Color.WHITE)

		var lines: Array[IbentoFileLine] = []
		IbentoFileWriter.shiito_to_file_lines(lines, _ibento.shiitos[_edit_shiito_idx])

		for i in range(0, lines.size()):
			file_text += lines[i].to_text() + "\n"
			#file_access.store_line(lines[i].word0 + "\t" + lines[i].word1)
		
	var caret_line: int = _ibento_file_edit.get_caret_line()
	var scroll_vertical: float = _ibento_file_edit.scroll_vertical
	_ibento_file_edit.text = file_text
	_ibento_file_edit.set_caret_line(caret_line, true)
	_ibento_file_edit.scroll_vertical = scroll_vertical



func _show_raw_text() -> void:

	if _ibento == null:
		return
	if _edit_shiito_idx < 0 or _edit_shiito_idx > _ibento.shiitos.size() - 1:
		return

	var lines: Array[IbentoFileLine] = _ibento.shiitos[_edit_shiito_idx].raw_lines

	var file_text: String = ""
	for i in range(0, lines.size()):
		file_text += lines[i].to_text() + "\n"

	var caret_line: int = _raw_text_edit.get_caret_line()
	var scroll_vertical: float = _raw_text_edit.scroll_vertical
	_raw_text_edit.text = file_text
	_raw_text_edit.set_caret_line(caret_line, true)
	_raw_text_edit.scroll_vertical = scroll_vertical
