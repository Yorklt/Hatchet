class_name IbentoFileWriter
extends Node


static func write(
		ibento: Ibento,
		path: String,
		) -> void:

	# フォルダ区切り文字置き換え
	path = path.replace("\\", "/")

	var file_access: FileAccess = FileAccess.open(path, FileAccess.WRITE)

	var lines: Array[IbentoFileLine] = []
	for i in range(0, ibento.shiitos.size()):
		var shiito: IbentoShiito = ibento.shiitos[i]
		IbentoFileWriter.shiito_to_file_text(lines, shiito)

	for i in range(0, lines.size()):
		var line: String = ""
		for k in range(0, lines[i].indent):
			line += "\t"
		line += lines[i].word0 + "\t" + lines[i].word1
		file_access.store_line(line)

	file_access.close()


static func shiito_to_file_text(lines: Array[IbentoFileLine], shiito: IbentoShiito) -> void:

	var line: IbentoFileLine = null
	var word0: String = ""
	var word1: String = ""

	if true:
		line = IbentoFileLine.new()
		line.word0 = "シート"
		line.word1 = ""
		lines.append(line)

	if true:
		line = IbentoFileLine.new()
		line.word0 = "スクリプト"
		line.word1 = ""
		lines.append(line)

	for i in range(0, shiito.panerus.size()):
		var paneru: Paneru = shiito.panerus[i]
		IbentoFileWriter.paneru_to_file_text(lines, paneru)

	if true:
		line = IbentoFileLine.new()
		line.word0 = "スクリプト終了"
		line.word1 = ""
		lines.append(line)

	if true:
		line = IbentoFileLine.new()
		line.word0 = "シート終了"
		line.word1 = ""
		lines.append(line)


static func paneru_to_file_text(lines: Array[IbentoFileLine], paneru: Paneru) -> void:
	
	#paneru.tip.reverse_into_paneru_params(paneru.params)
	var line: IbentoFileLine = null
	var word0: String = ""
	var word1: String = ""

	if true:
		word0 = "コマンド"
		word1 = Komando.Type.keys()[paneru.komando_type]
		line = IbentoFileLine.new()
		line.word0 = word0
		line.word1 = word1
		lines.append(line)
		
	for i in range(0, paneru.params.size()):
		var param: PaneruParam = paneru.params[i]
		
		if paneru.tip.error_text != "":
			word0 = "TIPエラー"
			word1 = paneru.tip.error_text

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
		line.indent = 1
		line.word0 = word0
		line.word1 = word1
		lines.append(line)

	if true:
		word0 = "コマンド終了"
		word1 = ""
		line = IbentoFileLine.new()
		line.word0 = word0
		line.word1 = word1
		lines.append(line)

	return
