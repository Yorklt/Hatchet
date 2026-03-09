class_name IbentoFileWriter
extends Node

# KomandoTypeとPaneruParamから、Word0とWord1を経由して、ファイルの書き込みまで。


static func write(
		ibento: Ibento,
		path: String,
		) -> void:

	# フォルダ区切り文字置き換え
	path = path.replace("\\", "/")

	var file_access: FileAccess = FileAccess.open(path, FileAccess.WRITE)

	var lines: Array[IbentoFileLine] = []

	if true:
		var line: IbentoFileLine = null
		line = IbentoFileLine.new()
		line.indent = 0
		line.word0 = "Guid"
		line.word1 = ibento.ibento_guid.to_text()
		lines.append(line)

	if true:
		var line: IbentoFileLine = null
		line = IbentoFileLine.new()
		line.indent = 0
		line.word0 = "イベント名"
		line.word1 = ibento.ibento_name
		lines.append(line)

	for i in range(0, ibento.shiitos.size()):
		var shiito: IbentoShiito = ibento.shiitos[i]
		IbentoFileWriter.shiito_to_file_lines(lines, shiito)

	for i in range(0, lines.size()):
		var line: String = lines[i].to_text()
		file_access.store_line(line)

	file_access.close()


static func shiito_to_file_lines(lines: Array[IbentoFileLine], shiito: IbentoShiito) -> void:

	var line: IbentoFileLine = null
	var word0: String = ""
	var word1: String = ""

	if true:
		line = IbentoFileLine.new()
		line.indent = 0
		line.word0 = "シート"
		line.word1 = shiito.shiito_name
		lines.append(line)

	for i in range(0, shiito.shiito_props.size()):
		var key: String = shiito.shiito_props.keys()[i]
		var val: String = shiito.shiito_props.values()[i]
		line = IbentoFileLine.new()
		line.indent = 1
		line.word0 = key
		line.word1 = val
		lines.append(line)

	if true:
		line = IbentoFileLine.new()
		line.indent = 1
		line.word0 = "スクリプト"
		line.word1 = ""
		lines.append(line)

	for i in range(0, shiito.panerus_props.size()):
		var key: String = shiito.panerus_props.keys()[i]
		var val: String = shiito.panerus_props.values()[i]
		line = IbentoFileLine.new()
		line.indent = 2
		line.word0 = key
		line.word1 = val
		lines.append(line)

	for i in range(0, shiito.panerus.size()):
		var paneru: Paneru = shiito.panerus[i]
		IbentoFileWriter.paneru_to_file_lines(lines, paneru)

	if true:
		line = IbentoFileLine.new()
		line.indent = 1
		line.word0 = "スクリプト終了"
		line.word1 = ""
		lines.append(line)

	if true:
		line = IbentoFileLine.new()
		line.indent = 0
		line.word0 = "シート終了"
		line.word1 = ""
		lines.append(line)


static func paneru_to_file_lines(lines: Array[IbentoFileLine], paneru: Paneru) -> void:
	
	#paneru.tip.reverse_into_paneru_params(paneru.params)
	var line: IbentoFileLine = null
	var word0: String = ""
	var word1: String = ""

	var has_error: bool = false
	if paneru.komando_type == Komando.Type.INVALID:
		word0 = "{{コマンドエラー}}"
		word1 = "{{" + paneru.reverse_error + "}}"
		line = IbentoFileLine.new()
		line.word0 = word0
		line.word1 = word1
		lines.append(line)
		has_error = true
	elif paneru.komando_type == Komando.Type.READ_ERROR:
		word0 = "{{読み込みエラー}}"
		word1 = "{{" + paneru.reverse_error + "}}"
		line = IbentoFileLine.new()
		line.word0 = word0
		line.word1 = word1
		lines.append(line)
		has_error = true
	elif paneru.komando_type == Komando.Type.INTERP_ERROR:
		word0 = "{{解釈エラー}}"
		word1 = "{{" + paneru.reverse_error + "}}"
		line = IbentoFileLine.new()
		line.word0 = word0
		line.word1 = word1
		lines.append(line)
		has_error = true
	elif paneru.komando_type == Komando.Type.KOMANDO:
		# べた書きコマンドは右から左に流す
		word0 = "コマンド"
		word1 = paneru.komando_as_str
		line = IbentoFileLine.new()
		line.word0 = word0
		line.word1 = word1
		lines.append(line)
	else:
		word0 = "コマンド"
		word1 = Komando.Type.keys()[paneru.komando_type]
		line = IbentoFileLine.new()
		line.indent = 2
		line.word0 = word0
		line.word1 = word1
		lines.append(line)

	if has_error == false:
		# くどいので、すでにエラー出してるならもう同じパネルで出さない
		# 読み込みエラーなら逆変換は失敗するだろうし
		if paneru.reverse_error != "":
			word0 = "{{逆変換エラー}}"
			word1 = "{{" + paneru.reverse_error + "}}"
			line = IbentoFileLine.new()
			line.indent = 0
			line.word0 = word0
			line.word1 = word1
			lines.append(line)
		
	for i in range(0, paneru.params.size()):
		var param: PaneruParam = paneru.params[i]

		var is_multi_lines: bool = false
		if param.param_type == PaneruParam.Type.JOKEN_ARG:
			is_multi_lines = true

		if is_multi_lines == false:
			if param.param_type == PaneruParam.Type.INT:
				word0 = "整数"
				word1 = "%d" % param.v_int
			elif param.param_type == PaneruParam.Type.FLOAT:
				word0 = "小数"
				word1 = "%f" % param.v_float
			elif param.param_type == PaneruParam.Type.STRING:
				word0 = "文字列"
				word1 = param.v_str
			elif param.param_type == PaneruParam.Type.GUID:
				word0 = "Guid"
				word1 = param.v_str
			elif param.param_type == PaneruParam.Type.VARIABLE:
				word0 = "変数"
				word1 = param.v_str
			elif param.param_type == PaneruParam.Type.LOCAL:
				word0 = "ローカル変数"
				word1 = param.v_str
			elif param.param_type == PaneruParam.Type.ARRAY:
				word0 = "配列変数"
				word1 = param.v_str
		
			line = IbentoFileLine.new()
			line.indent = 3
			line.word0 = word0
			line.word1 = word1
			lines.append(line)

		else:
			if param.param_type == PaneruParam.Type.JOKEN_ARG:
				line = IbentoFileLine.new()
				line.indent = 3
				line.word0 = "条件引数"
				line.word1 = ""
				lines.append(line)
				
				for k in range(0, param.v_jokens.size()):
					var joken: Joken = param.v_jokens[k]
					line = IbentoFileLine.new()
					line.indent = 3
					line.word0 = "条件"
					if joken.joken_type == Joken.Type.COND_TYPE_VARIABLE:
						line.word1 = "COND_TYPE_VARIABLE"
					elif joken.joken_type == Joken.Type.COND_TYPE_ARRAY_VAR:
						line.word1 = "COND_TYPE_ARRAY_VAR"
					elif joken.joken_type == Joken.Type.COND_TYPE_SWITCH:
						line.word1 = "COND_TYPE_SWITCH"
					elif joken.joken_type == Joken.Type.COND_TYPE_ARRAY_SW:
						line.word1 = "COND_TYPE_ARRAY_SW"
					lines.append(line)

					line = IbentoFileLine.new()
					line.indent = 4
					line.word0 = "比較演算子"
					if joken.operator == 0:
						line.word1 = "EQUAL"
					elif joken.operator == 1:
						line.word1 = "NOT_EQUAL"
					elif joken.operator == 2:
						line.word1 = "EQUAL_GREATER"
					elif joken.operator == 3:
						line.word1 = "EQUAL_LOWER"
					elif joken.operator == 4:
						line.word1 = "LOWER"
					elif joken.operator == 5:
						line.word1 = "GREATER"
					lines.append(line)

					line = IbentoFileLine.new()
					line.indent = 4
					line.word0 = "インデックス"
					line.word1 = "%d" % joken.index
					lines.append(line)

					line = IbentoFileLine.new()
					line.indent = 4
					line.word0 = "オプション"
					line.word1 = "%d" % joken.option
					lines.append(line)

					line = IbentoFileLine.new()
					line.indent = 4
					line.word0 = "ローカル参照"
					if joken.rokaru_ref == true:
						line.word1 = "True"
					else:
						line.word1 = "False"
					lines.append(line)

					line = IbentoFileLine.new()
					line.indent = 4
					line.word0 = "ポインタ"
					line.word1 = "%d" % joken.pointa
					lines.append(line)

					line = IbentoFileLine.new()
					line.indent = 4
					line.word0 = "ポインタ名"
					line.word1 = joken.pointa_name
					lines.append(line)

					line = IbentoFileLine.new()
					line.indent = 4
					line.word0 = "参照名"
					line.word1 = joken.ref_name
					lines.append(line)

					line = IbentoFileLine.new()
					line.indent = 3
					line.word0 = "条件終了"
					line.word1 = ""
					lines.append(line)
				
				line = IbentoFileLine.new()
				line.indent = 3
				line.word0 = "条件引数終了"
				line.word1 = ""
				lines.append(line)

	if paneru.komando_type != Komando.Type.INVALID:
		word0 = "コマンド終了"
		word1 = ""
		line = IbentoFileLine.new()
		line.indent = 2
		line.word0 = word0
		line.word1 = word1
		lines.append(line)

	return
