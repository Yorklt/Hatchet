class_name MainWindow
extends Control

var _filepath_line_edit: LineEdit = null
var _file_dialog_button: Button = null
var _load_button: Button = null
var _save_button: Button = null
var _shiito_list: ItemList = null
var _content_edit: TextEdit = null
var _file_dialog: FileDialog = null

var _ibento: Ibento = null



func _ready() -> void:

	# シーン埋め込みのノード取得
	_filepath_line_edit = $FilepathEdit as LineEdit
	_file_dialog_button = $FileDialogButton as Button
	_load_button = $LoadButton as Button
	_save_button = $SaveButton as Button
	_shiito_list = $ShiitoList as ItemList
	_content_edit = $ContentEdit as TextEdit

	# ファイルパスの入力欄
	_filepath_line_edit.text_changed.connect(_on_filepath_line_edit_text_changed)

	# ファイル選択ダイアログを開くボタン
	_file_dialog_button.pressed.connect(_on_file_dialog_button_pressed)

	# ロードボタン
	_load_button.disabled = true
	_load_button.pressed.connect(_on_load_button_pressed)

	# シートリスト
	_shiito_list.item_selected.connect(_on_shiito_list_selected)

	# 内容エディタ
	_content_edit.editable = false

	# 内容エディタハイライト
	var highlighter: CodeHighlighter = CodeHighlighter.new()
	highlighter.number_color = Color.WHITE
	highlighter.symbol_color = Color.WHITE
	highlighter.function_color = Color.WHITE
	highlighter.add_keyword_color("if", Color.DODGER_BLUE)
	highlighter.add_keyword_color("else", Color.DODGER_BLUE)
	highlighter.add_keyword_color("endif", Color.DODGER_BLUE)
	highlighter.add_keyword_color("loop", Color.DODGER_BLUE)
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

	highlighter.add_keyword_color("exclude", Color.DIM_GRAY)
	highlighter.add_keyword_color("endex", Color.DIM_GRAY)

	highlighter.add_color_region("//", "", Color.DIM_GRAY, true)
	highlighter.add_color_region("[[", "]]", Color.AQUAMARINE, false)
	highlighter.add_color_region("<<", ">>", Color.DARK_KHAKI, false)
	highlighter.add_color_region("\"", "\"", Color.CHOCOLATE, false)

	_content_edit.syntax_highlighter = highlighter


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

	_shiito_list.clear()
	for i in range(0, _ibento.shiitos.size()):
		_shiito_list.add_item(_ibento.shiitos[i].shiito_name)

	var shiito_idx: int = 0
	_show_paneru_text(shiito_idx)


func _on_shiito_list_selected(index: int) -> void:
	_show_paneru_text(index)


func _update_load_save_buttons() -> void:

	var path: String = _filepath_line_edit.text

	# ファイルが存在すればボタン有効
	if path != "":
		if FileAccess.file_exists(path) == true:
			_load_button.disabled = false
			_load_button.text = "読み込み"
			_save_button.disabled = false
			_save_button.text = "上書き（未実装）"
		else:
			_load_button.disabled = true
			_load_button.text = "存在しません"
			_save_button.disabled = false
			_save_button.text = "新規保存（未実装）"
	else:
		_load_button.disabled = true
		_load_button.text = ""
		_save_button.disabled = true
		_save_button.text = ""


func _show_paneru_text(shiito_idx: int) -> void:
	if _ibento == null:
		return
	if shiito_idx < 0 or shiito_idx > _ibento.shiitos.size() - 1:
		return

	var text: String = ""
	var indent_count: int = 0
	var begin_stack: Array[Komando.Type] = []
	for i in range(0, _ibento.shiitos[shiito_idx].panerus.size()):
		
		var paneru: Paneru = _ibento.shiitos[shiito_idx].panerus[i]
		var komando_type: Komando.Type = paneru.komando_type
		var last_begin: Komando.Type = Komando.Type.INVALID
		if begin_stack.size() > 0:
			last_begin = begin_stack.back()
		var paneru_text: String = paneru.to_text(last_begin)

		var block_type: TIP.BlockType = TIP.BlockType.NONE
		if paneru.tip != null:
			block_type = paneru.tip.block_type
		var sub_indext: int = 0
		var sub_indext_next: int = 0

		if block_type == TIP.BlockType.BEGIN:
			# これの後は下げる
			begin_stack.append(komando_type)
			sub_indext = 0
			sub_indext_next = 1
		elif block_type == TIP.BlockType.CONTINUE:
			# これだけ上げる
			sub_indext = -1
			sub_indext_next = 0
		elif block_type == TIP.BlockType.END:
			# これ以降下げる
			begin_stack.pop_back()
			sub_indext = -1
			sub_indext_next = -1

		var lines: PackedStringArray = paneru_text.split("\n", false)
		for n in range(0, lines.size()):
			for k in range(0, indent_count + sub_indext):
				text += "\t"
			if n > 0:
				text += "\t" # 複数行から成るなら、2行目以降はさらにインデントする
			text += lines[n]
			text += "\n"
		indent_count += sub_indext_next
	_content_edit.text = text
	_content_edit.editable = true
