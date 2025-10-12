class_name IbentoFileReader
extends Node

# ファイルの読み込みから、Word0とWord1を経由して、KomandoTypeとPaneruParamuまで。


static func read(
		dst_result: Ibento,
		path: String,
		) -> void:

	# フォルダ区切り文字置き換え
	path = path.replace("\\", "/")

	if FileAccess.file_exists(path) == false:
		return

	var file_access: FileAccess = FileAccess.open(path, FileAccess.READ)

	# 各行をタブ区切りの1個か2個のワードに分ける
	var lines: Array[IbentoFileLine] = []
	while file_access.get_position() < file_access.get_length():
		var line: String = file_access.get_line()
		if line.length() <= 0: # 空業は無いはずだけども。
			continue
		var words: PackedStringArray = line.split("\t", false)
		var ibento_file_line: IbentoFileLine = IbentoFileLine.new()
		if words.size() == 1:
			ibento_file_line.word0 = words[0]
			ibento_file_line.word1 = "" # Word1を伴うWord0でも空欄の場合もある
		elif words.size() == 2:
			ibento_file_line.word0 = words[0]
			ibento_file_line.word1 = words[1]
		else:
			# エラー
			print(words.size())
			pass
		lines.append(ibento_file_line)

	file_access.close()

	IbentoFileReader.parse(dst_result, lines, 0)


static func parse(dst_ibento: Ibento, lines: Array[IbentoFileLine], idx0: int) -> int:
	var idx: int = idx0
	for i in range(0, lines.size()):
		var word0: String = lines[idx].word0
		var word1: String = lines[idx].word1
		if word0 == "Guid":
			pass
		elif word0 == "イベント名":
			dst_ibento.ibento_name = word1
		elif word0 == "シート":
			var shiito: IbentoShiito = IbentoShiito.new()
			idx = IbentoFileReader.parse_shiito(shiito, lines, idx)
			dst_ibento.shiitos.append(shiito)
			# ファイルの端まで行ったら終了
			if idx >= lines.size() - 1:
				return 0
		else:
			# その他
			pass
		idx += 1
	return 0


static func parse_shiito(dst_shiito: IbentoShiito, lines: Array[IbentoFileLine], idx0: int) -> int:
	var idx: int = idx0
	for i in range(0, lines.size()):
		var word0: String = lines[idx].word0
		var word1: String = lines[idx].word1
		if word0 == "シート":
			dst_shiito.shiito_name = word1
		elif word0 == "スクリプト":
			idx = IbentoFileReader.parse_panerus(dst_shiito.panerus, lines, idx)
		elif word0 == "シート終了":
			return idx
		else:
			# その他
			pass
		idx += 1
	return -1


static func parse_panerus(dst_panerus: Array[Paneru], lines: Array[IbentoFileLine], idx0: int) -> int:
	var idx: int = idx0
	for i in range(0, lines.size()):
		var word0: String = lines[idx].word0
		if word0 == "スクリプト":
			pass
		elif word0 == "開始条件":
			pass
		elif word0 == "コマンド":
			var paneru: Paneru = Paneru.new()
			idx = IbentoFileReader.parse_paneru(paneru, lines, idx)
			dst_panerus.append(paneru)
		elif word0 == "スクリプト終了":
			return idx
		else:
			# その他
			pass
		idx += 1
	return -1


static func parse_paneru(dst_paneru: Paneru, lines: Array[IbentoFileLine], idx0: int) -> int:
	var idx: int = idx0
	for i in range(0, lines.size()):
		var word0: String = lines[idx].word0
		var word1: String = lines[idx].word1
		if word0 == "コマンド":
			dst_paneru.komando_as_str = word1
			dst_paneru.komando_type = Komando.parse_str(word1)
		elif word0 == "整数":
			if word1.is_valid_int() == true:
				var param: PaneruParam = PaneruParam.new()
				param.param_type = PaneruParam.Type.INT
				param.v_int = word1.to_int()
				dst_paneru.params.append(param)
			else:
				# エラー
				pass
		elif word0 == "小数":
			if word1.is_valid_float() == true:
				var param: PaneruParam = PaneruParam.new()
				param.param_type = PaneruParam.Type.FLOAT
				param.v_float = word1.to_float()
				dst_paneru.params.append(param)
			else:
				# エラー
				pass
		elif word0 == "文字列":
				var param: PaneruParam = PaneruParam.new()
				param.param_type = PaneruParam.Type.STRING
				param.v_str = word1
				dst_paneru.params.append(param)
		elif word0 == "Guid":
			if word1.length() == 36:
				var param: PaneruParam = PaneruParam.new()
				param.param_type = PaneruParam.Type.GUID
				param.v_str = word1
				dst_paneru.params.append(param)
			else:
				# エラー
				pass
		elif word0 == "スポット":
			var param: PaneruParam = PaneruParam.new()
			param.param_type = PaneruParam.Type.SUPOTTO
			param.v_str = word1
			dst_paneru.params.append(param)
		elif word0 == "変数":
			var param: PaneruParam = PaneruParam.new()
			param.param_type = PaneruParam.Type.VARIABLE
			param.v_str = word1
			dst_paneru.params.append(param)
		elif word0 == "ローカル変数":
			var param: PaneruParam = PaneruParam.new()
			param.param_type = PaneruParam.Type.LOCAL
			param.v_str = word1
			dst_paneru.params.append(param)
		elif word0 == "配列変数":
			var param: PaneruParam = PaneruParam.new()
			param.param_type = PaneruParam.Type.ARRAY
			param.v_str = word1
			dst_paneru.params.append(param)
		elif word0 == "条件引数":
			var param: PaneruParam = PaneruParam.new()
			param.param_type = PaneruParam.Type.JOKEN_ARG

			var arg_end_found: bool = false
			while (arg_end_found == false):

				var sub_w0: String = lines[idx].word0

				if sub_w0 == "条件引数":
					pass

				elif sub_w0 == "条件":

					var joken: Joken = Joken.new()
					var joken_end_found: bool = false
					while (joken_end_found == false):

						var sub_sub_w0: String = lines[idx].word0
						var sub_sub_w1: String = lines[idx].word1

						if sub_sub_w0 == "条件":
							if sub_sub_w1 == "COND_TYPE_VARIABLE":
								joken.joken_type = Joken.Type.COND_TYPE_VARIABLE
							elif sub_sub_w1 == "COND_TYPE_ARRAY_VAR":
								joken.joken_type = Joken.Type.COND_TYPE_ARRAY_VAR
							elif sub_sub_w1 == "COND_TYPE_SWITCH":
								joken.joken_type = Joken.Type.COND_TYPE_SWITCH
							elif sub_sub_w1 == "COND_TYPE_ARRAY_SW":
								joken.joken_type = Joken.Type.COND_TYPE_ARRAY_SW
							else:
								# エラー
								pass
						elif sub_sub_w0 == "比較演算子":
							joken.operator = -1
						elif sub_sub_w0 == "インデックス":
							joken.index = sub_sub_w1.to_int()
						elif sub_sub_w0 == "オプション":
							joken.option = sub_sub_w1.to_int()
						elif sub_sub_w0 == "ローカル参照":
							if sub_sub_w1 == "True":
								joken.rokaru_ref = true
							else:
								joken.rokaru_ref = false
						elif sub_sub_w0 == "ポインタ":
							joken.pointa = sub_sub_w1.to_int()
						elif sub_sub_w0 == "ポインタ名":
							joken.pointa_name = sub_sub_w1
						elif sub_sub_w0 == "参照名":
							joken.ref_name = sub_sub_w1
						elif sub_sub_w0 == "条件終了":
							joken_end_found = true
						else:
							# TBD
							pass

						idx += 1

					# この時点でidxは"条件終了"の次
					param.v_jokens.append(joken)
					continue # "条件"または"条件引数終了"へ

				elif sub_w0 == "条件引数終了":
					arg_end_found = true
				else:
					# エラー
					print(sub_w0)

				idx += 1

			# この時点でidxは"条件引数終了"の次
			dst_paneru.params.append(param)
			continue # "条件引数"または次のパラメータへ
		elif word0 == "コマンド終了":
			return idx
		else:
			# その他
			pass
		idx += 1
	return -1
