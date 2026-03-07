class_name Hatchet
extends Node

var _file_history: FileHistory = null

var _loaded_path: String = ""
var _ibento: Ibento = null
var _edit_texts: Array[String] = []
var _reverse_error_count: Array[int] = []


func _init() -> void:
	_file_history = FileHistory.new()


func load_user_settings() -> void:

	# C:/Users/Poco/AppData/Roaming/Godot/app_userdata/Hatchet/
	# または
	# C:/Users/Poco/AppData/Roaming/プロジェクト設定でカスタムした文字列/
	#print(OS.get_user_data_dir())
	#print(ProjectSettings.globalize_path("user://"))

	var filepath: String = ProjectSettings.globalize_path("user://FileHistory.txt")
	_file_history.load_from_file(filepath)


func save_user_settings() -> void:
	var filepath: String = ProjectSettings.globalize_path("user://FileHistory.txt")
	_file_history.save_to_file(filepath)


func get_file_history_paths_copy() -> Array[String]:
	return _file_history.paths.duplicate(false)


func is_shiito_idx_valid(shiito_idx: int) -> bool:
	
	if _ibento == null:
		return false
	if shiito_idx < 0 or shiito_idx > _ibento.shiitos.size() - 1:
		return false
	if shiito_idx < 0 or shiito_idx > _edit_texts.size() - 1:
		return false

	return true


func load_ibento(path: String) -> void:

	if FileAccess.file_exists(path) == false:
		return

	_ibento = Ibento.new()
	IbentoFileReader.read(_ibento, path)

	# 履歴に追加
	_file_history.add_path(path)
	
	# 現在開いているファイル
	_loaded_path = path

	# コマンドからTIPに変換
	for i in range(0, _ibento.shiitos.size()):
		var dst_error_count: Array[int] = []
		TIPResolver.transcript_panels(dst_error_count, _ibento.shiitos[i].panerus)
		_ibento.shiitos[i].trans_error_count = dst_error_count[0]

	# TIPから編集テキストに変換
	_edit_texts.clear()
	for i in range(0, _ibento.shiitos.size()):
		var dst_text: Array[String] = []
		TIPTranslator.panerus_to_tip_text(dst_text, _ibento.shiitos[i].panerus)
		_edit_texts.append("")
		_edit_texts[i] = dst_text[0]

	_reverse_error_count.clear()
	for i in range(0, _ibento.shiitos.size()):
		_reverse_error_count.append(-1)


func can_save_ibento() -> bool:

	if _ibento == null:
		return false
	for i in range(0, _ibento.shiitos.size()):
		if _reverse_error_count[i] < 0:
			return false # 逆変換がまだ
		if _reverse_error_count[i] > 0:
			return false

	return true


func save_ibento(path: String) -> void:

	if _ibento == null:
		return
	IbentoFileWriter.write(_ibento, path)


func get_loaded_path() -> String:

	if _ibento == null:
		return ""

	return _loaded_path


func get_ibento_name() -> String:

	if _ibento == null:
		return ""

	return _ibento.ibento_name


func get_shiito_names() -> Array[String]:

	if _ibento == null:
		return []

	var shiito_names: Array[String] = []
	for i in range(0, _ibento.shiitos.size()):
		shiito_names.append(_ibento.shiitos[i].shiito_name)

	return shiito_names


func get_trans_error_count(shiito_idx: int) -> int:
	if is_shiito_idx_valid(shiito_idx) == false:
		return 0
	return _ibento.shiitos[shiito_idx].trans_error_count


func set_edit_text(shiito_idx: int, edit_text: String) -> void:

	if is_shiito_idx_valid(shiito_idx) == false:
		return
	_edit_texts[shiito_idx] = edit_text


func get_edit_text(shiito_idx: int) -> String:

	if is_shiito_idx_valid(shiito_idx) == false:
		return ""
	return _edit_texts[shiito_idx]


func get_reverse_error_count(shiito_idx: int) -> int:

	if is_shiito_idx_valid(shiito_idx) == false:
		return -1
	return _reverse_error_count[shiito_idx]


func get_raw_lines(shiito_idx: int) -> Array[IbentoFileLine]:

	if is_shiito_idx_valid(shiito_idx) == false:
		return []
	return _ibento.shiitos[shiito_idx].raw_lines


# これを呼ぶ前に、必要に応じて（ほぼ必要）、set_edit_textでテキストを更新すること。
func reverse_tip(shiito_idx: int) -> int:

	if is_shiito_idx_valid(shiito_idx) == false:
		return -1

	var error_count: int = 0

	var text: String = ""
	text = _edit_texts[shiito_idx]

	# TIPからパネルに逆変換
	# イベントのパネルを置き換える
	var panerus: Array[Paneru] = []
	TIPReverser.tip_text_to_panerus(panerus, text)
	_ibento.shiitos[shiito_idx].panerus = panerus
	
	for i in range(0, panerus.size()):
		if panerus[i].reverse_error != "":
			error_count += 1

	_reverse_error_count[shiito_idx] = error_count

	return error_count


func shiito_to_file_text(shiito_idx: int) -> String:

	if is_shiito_idx_valid(shiito_idx) == false:
		return ""

	var lines: Array[IbentoFileLine] = []
	IbentoFileWriter.shiito_to_file_lines(lines, _ibento.shiitos[shiito_idx])

	var file_text: String = ""
	for i in range(0, lines.size()):
		file_text += lines[i].to_text() + "\n"

	return file_text
