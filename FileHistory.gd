class_name FileHistory
extends Node

# 後のIndexほど最近開いたファイル
var paths: Array[String] = []


func load_from_file(path: String) -> void:

	if FileAccess.file_exists(path) == false:
		return

	paths.clear()

	var file_access: FileAccess = FileAccess.open(path, FileAccess.READ)

	while file_access.get_position() < file_access.get_length():
		var line: String = file_access.get_line()
		if line.length() <= 0: # 空業は飛ばす
			continue
		paths.append(line)

	file_access.close()


func save_to_file(path: String) -> void:

	var file_access: FileAccess = FileAccess.open(path, FileAccess.WRITE)

	for i in range(0, paths.size()):
		if paths[i].length() <= 0: # 空業は飛ばす
			continue
		file_access.store_line(paths[i])

	file_access.close()


func add_path(path: String) -> void:

	var idx: int = paths.find(path)
	if idx >= 0:
		# 同じものを追加しようとしたときは、一度取り除いて最新にする
		paths.remove_at(idx)

	paths.append(path)

	# 許容量を超えたら古いのは削除
	if paths.size() > 20:
		paths.pop_front()
