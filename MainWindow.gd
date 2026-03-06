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
var _reversed_file_edit: TextEdit = null
var _raw_text_edit: TextEdit = null
var _error_count_label: Label = null
var _file_dialog: FileDialog = null

var _hatchet: Hatchet = null

var _edit_shiito_idx: int = -1
var _does_auto_reverse: bool = true
var _is_content_edited: bool = false
var _content_edit_time: float = 0.0


func _ready() -> void:

	# シーン埋め込みのノード取得
	_filepath_line_edit = $FilepathEdit as LineEdit
	_file_dialog_button = $FileDialogButton as Button
	_load_button = $LoadButton as Button
	_save_button = $SaveButton as Button
	_shiito_list = $ShiitoList as ItemList
	_content_edit = $HSplitContainer/ContentEdit as TextEdit
	_reverse_button = $ReverseButton as Button
	_auto_reverse_check_button = $AutoReverseCheckButton as CheckButton
	_reversed_file_edit = $HSplitContainer/TabContainer/Reversed/IbentoFileText as TextEdit
	_raw_text_edit = $HSplitContainer/TabContainer/Raw/OriginalText as TextEdit
	_error_count_label = $ErrorCount as Label

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
	
	# 逆変換後のテキスト
	_reversed_file_edit.caret_changed.connect(_on_ibento_file_edit_caret_changed)
	
	# 生データテキスト
	_reversed_file_edit.editable = false

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

	# 逆変換後テキストのハイライト
	# エラーだけ目立たせる
	var highlighter_file: CodeHighlighter = CodeHighlighter.new()
	highlighter_file.number_color = Color.WHITE
	highlighter_file.symbol_color = Color.WHITE
	highlighter_file.function_color = Color.WHITE
	highlighter_file.add_color_region("{{", "}}", Color.BURLYWOOD, false)
	_reversed_file_edit.syntax_highlighter = highlighter_file

	_hatchet = Hatchet.new()


func _process(delta: float) -> void:
	_content_edit_time = clamp(_content_edit_time - delta, 0.0, 99.0)
	if _does_auto_reverse == true and _is_content_edited == true:
		if _content_edit_time <= 0.0:
			_is_content_edited = false
			_content_edit_time = 1.0
			_reverse_tip_and_show_ibento_file_text()


func _on_filepath_line_edit_text_changed(_text: String) -> void:
	_update_load_button()


# ファイルダイアログ

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

		file_dialog.current_dir = "C:/"

		get_tree().root.add_child(file_dialog)


func _on_file_dialog_file_selected(path: String) -> void:

	_file_dialog.queue_free()
	_file_dialog = null

	_filepath_line_edit.text = path
	_update_load_button()
	
	_load_ibento()


func _on_file_dialog_canceled() -> void:

	_file_dialog.queue_free()
	_file_dialog = null


func _on_load_button_pressed() -> void:

	_load_ibento()


func _on_save_button_pressed() -> void:

	_save_ibento()


func _on_shiito_list_selected(index: int) -> void:
	_edit_shiito_idx = index
	var edit_text: String = _hatchet.get_edit_text(_edit_shiito_idx)
	_content_edit.text = edit_text
	_content_edit.editable = true
	_show_raw_text()


func _on_content_edit_lines_edited_from(_from_line: int, _to_line: int) -> void:
	# 自動逆変換モードでも、毎回逆変換するのではなく、
	# フラグを立てておいて、定期的に逆変換する。
	_is_content_edited = true


func _on_ibento_file_edit_caret_changed() -> void:
	pass
	#if _ibento == null:
		#return
	#if _edit_shiito_idx < 0 or _edit_shiito_idx > _ibento.shiitos.size() - 1:
		#return
#
	#var line_at: int = _ibento_file_edit.get_caret_line(0)
#
	#var paneru_idx: int = 0
	#for i in range(0, _ibento.shiitos[_edit_shiito_idx].panerus.size()):
		#if _ibento.shiitos[_edit_shiito_idx].panerus[i].edit_line_idx == line_at:
			#paneru_idx = 0


func _update_load_button() -> void:

	var path: String = _filepath_line_edit.text

	# ファイルが存在すればボタン有効
	if path != "":
		if FileAccess.file_exists(path) == true:
			_load_button.disabled = false
			_load_button.text = "読み込み"
		else:
			_load_button.disabled = true
			_load_button.text = "存在しません"
	else:
		_load_button.disabled = true
		_load_button.text = ""


func _update_save_button() -> void:

	var can_save: bool = _hatchet.can_save_ibento()
	if can_save == true: # セーブできるならボタンを押せない(disable)ことがない(false)
		_save_button.disabled = false
	if can_save == false: # セーブできないならボタンを押せない(disable)でよろしい(true)
		_save_button.disabled = true

	var path: String = _filepath_line_edit.text

	# 接尾辞を付ける
	var extension: String = path.get_extension()
	path = path.left(0 - extension.length() - 1) # 拡張子とピリオドを取り除く
	path += "_mod"
	path += "." + extension

	# ファイルの有無で表示を変える
	if FileAccess.file_exists(path) == true:
		_save_button.disabled = false
		_save_button.text = "上書き"
	else:
		_save_button.disabled = false
		_save_button.text = "新規保存"


func _on_reverse_button_pressed() -> void:

	_reverse_tip_and_show_ibento_file_text()


func _on_auto_reverse_check_button_toggled(toggled_on: bool) -> void:
	_does_auto_reverse = toggled_on



func _reverse_tip_and_show_ibento_file_text() -> void:

	# 編集テキストをHatchetに反映
	_hatchet.set_edit_text(_edit_shiito_idx, _content_edit.text)

	var error_count: int = _hatchet.reverse_tip(_edit_shiito_idx)
	if error_count > 0:
		# エラーがあっても続ける
		pass
	
	var file_text: String = _hatchet.shiito_to_file_text(_edit_shiito_idx)
	
	# カーソル位置をできるだけ維持したまま更新
	var caret_line: int = _reversed_file_edit.get_caret_line()
	var scroll_vertical: float = _reversed_file_edit.scroll_vertical
	_reversed_file_edit.text = file_text
	_reversed_file_edit.set_caret_line(caret_line, true)
	_reversed_file_edit.scroll_vertical = scroll_vertical



func _show_raw_text() -> void:

	var lines: Array[IbentoFileLine] = _hatchet.get_raw_lines(_edit_shiito_idx)

	var file_text: String = ""
	for i in range(0, lines.size()):
		file_text += lines[i].to_text() + "\n"

	# カーソル位置をできるだけ維持したまま更新
	var caret_line: int = _raw_text_edit.get_caret_line()
	var scroll_vertical: float = _raw_text_edit.scroll_vertical
	_raw_text_edit.text = file_text
	_raw_text_edit.set_caret_line(caret_line, true)
	_raw_text_edit.scroll_vertical = scroll_vertical


func _load_ibento() -> void:
	
	var path: String = _filepath_line_edit.text

	_hatchet.load_ibento(path)

	_shiito_list.clear()
	var names: Array[String] = _hatchet.get_shiito_names()
	for i in range(0, names.size()):
		_shiito_list.add_item(names[i])

	_edit_shiito_idx = 0
	var edit_text: String = _hatchet.get_edit_text(_edit_shiito_idx)
	_content_edit.text = edit_text
	_content_edit.editable = true
	_show_raw_text()


func _save_ibento() -> void:

	var path: String = _filepath_line_edit.text

	# 接尾辞を付ける
	var extension: String = path.get_extension()
	path = path.left(0 - extension.length() - 1) # 拡張子とピリオドを取り除く
	path += "_mod"
	path += "." + extension

	_hatchet.save_ibento(path)
