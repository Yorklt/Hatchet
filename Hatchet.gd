class_name Hatchet
extends Node

var _ibento: Ibento = null
var _edit_texts: Array[String] = []


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

	# コマンドからTIPに変換
	for i in range(0, _ibento.shiitos.size()):
		TIPResolver.transcript_panels(_ibento.shiitos[i].panerus)

	# TIPから編集テキストに変換
	_edit_texts.clear()
	for i in range(0, _ibento.shiitos.size()):
		var dst_text: Array[String] = []
		TIPTWriter.panerus_to_tip_text(dst_text, _ibento.shiitos[i].panerus)
		_edit_texts.append("")
		_edit_texts[i] = dst_text[0]

	for i in range(0, _ibento.shiitos.size()):
		var error_count: int = 0
		for k in range(0, _ibento.shiitos[i].panerus.size()):
			if _ibento.shiitos[i].panerus[k].tip.error_text != "":
				error_count += 1
		_ibento.shiitos[i].komando_to_tip_error_count = error_count


func can_save_ibento() -> bool:

	if _ibento == null:
		return false
	for i in range(0, _ibento.shiitos.size()):
		if _ibento.shiitos[i].komando_to_tip_error_count > 0:
			return false

	return true


func save_ibento(path: String) -> void:

	if _ibento == null:
		return
	IbentoFileWriter.write(_ibento, path)


func get_shiito_names() -> Array[String]:

	if _ibento == null:
		return []

	var shiito_names: Array[String] = []
	for i in range(0, _ibento.shiitos.size()):
		shiito_names.append(_ibento.shiitos[i].shiito_name)

	return shiito_names


func set_edit_text(shiito_idx: int, edit_text: String) -> void:

	if is_shiito_idx_valid(shiito_idx) == false:
		return
	_edit_texts[shiito_idx] = edit_text


func get_edit_text(shiito_idx: int) -> String:

	if is_shiito_idx_valid(shiito_idx) == false:
		return ""
	return _edit_texts[shiito_idx]


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
	TIPTReader.tip_text_to_panerus(panerus, text)
	_ibento.shiitos[shiito_idx].panerus = panerus
	
	for i in range(0, panerus.size()):
		if panerus[i].reverse_error != "":
			error_count += 1

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
