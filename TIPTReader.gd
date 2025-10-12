class_name TIPTReader
extends Node

# TIPテキストからTIPEditLineを経由して、KomandoTypeとPaneruParamuまで。



# 区切り文字で分割
# String.splitは複数の区切り文字に対応していないので用意した。
# \nと\rを入れて、allow_emptyをfalseにすれば、改行文字の種類気にしなく済むよ。
static func split_text_with_delimiters(text: String, delimiters: Array[String], allow_empty: bool) -> Array[String]:

	var texts: Array[String] = []
	texts.append(text)
	
	const max_split: int = 0 # 無制限
	for delimite_idx: int in range(0, delimiters.size()):
		var texts_to_stlip: Array[String] = []
		texts_to_stlip.append_array(texts)
		texts = []
		for text_to_stlip: String in texts_to_stlip:
			var sub_array: PackedStringArray = text_to_stlip.split(delimiters[delimite_idx], allow_empty, max_split)
			for sub_text: String in sub_array:
				texts.append(sub_text)
	
	return texts


static func tip_text_to_panerus(dst_panerus: Array[Paneru], text: String) -> void:
	
	var edit_lines: Array[TIPEditLine] = []

	# テキストを行に分割
	if true:
		var delimiters: Array[String] = ["\n", "\r", "\t"]
		var allow_empty: bool = false # 空業は飛ばす
		var lines: Array[String] = TIPTReader.split_text_with_delimiters(text, delimiters, allow_empty)
		for i in range(0, lines.size()):
			var edit_line: TIPEditLine = TIPEditLine.new()
			edit_line.line = lines[i]
			edit_lines.append(edit_line)

	var line_idx: int = 0
	for i: int in range(0, edit_lines.size()):
		if line_idx > edit_lines.size() - 1:
			break
		var edit_line: TIPEditLine = edit_lines[line_idx]

		# 最初のワードを覗き見る
		edit_line.loc = 0 # 位置を戻してやる
		var word: String = edit_line.try_get_next_word()
		edit_line.loc = 0 # 位置を戻してやる
		if word == "": # 空業を飛ばしているのでありえないパス
			line_idx += 1
			continue

		var paneru: Paneru = Paneru.new()
		dst_panerus.append(paneru)

		# コマンドを判別
		var komando_type: Komando.Type = TIPResolver.try_solve_initial_word(word)
		if komando_type == Komando.Type.INVALID:
			# 未対応コマンド、または複数行にわたる未判定コマンドの後の行、またはただの判別不能
			paneru.komando_as_str = "?"
			paneru.komando_type = Komando.Type.INVALID
			paneru.tipt_error = "行の最初のワードが不明: " + word
			line_idx += 1
			continue
		paneru.komando_type = komando_type
		var komando_as_str: String = Komando.Type.keys()[komando_type]
		paneru.komando_as_str = komando_as_str

		# 複数行をTIPパラメータに変換
		var tip: TIP = TIPResolver.try_create_tip_by_komando(komando_type)
		if tip == null:
			# TIP未対応コマンド
			paneru.tipt_error = "TIP未対応コマンド: " + Komando.Type.keys()[komando_type]
			line_idx += 1
			continue
		paneru.tip = tip
		var line_idx_next: Array[int] = []
		tip.from_edit_lines(line_idx_next, edit_lines, line_idx)
		if line_idx_next[0] < 0: # TIPTエラー
			line_idx += 1
			continue
		line_idx = line_idx_next[0]

		# TIPパラメータをPaneruParamにする
		paneru.tip.reverse_into_paneru_params(paneru.params)
