class_name TIPReverser
extends Node

# TIPテキストからTIPEditLineを経由して、KomandoTypeとPaneruParamまで。



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
		var delimiters: Array[String] = ["\n", "\r"] # タブは含まないよ
		var allow_empty: bool = false # 空業は飛ばす
		var lines: Array[String] = TIPReverser.split_text_with_delimiters(text, delimiters, allow_empty)
		for i in range(0, lines.size()):
			var edit_line: TIPEditLine = TIPEditLine.new()
			edit_line.line = lines[i]
			edit_lines.append(edit_line)

	var line_idx: int = 0
	for i: int in range(0, edit_lines.size()):
		if line_idx > edit_lines.size() - 1:
			break
		var edit_line: TIPEditLine = edit_lines[line_idx]

		# 最初の3ワードを覗き見る
		edit_line.loc = 0 # 位置を戻してやる
		var word0: String = edit_line.try_get_next_word()
		var word1: String = edit_line.try_get_next_word()
		var word2: String = edit_line.try_get_next_word()
		edit_line.loc = 0 # 位置を戻してやる

		var paneru: Paneru = Paneru.new()
		dst_panerus.append(paneru)

		paneru.edit_line_idx = line_idx

		# コマンドを判別
		var komando_type: Komando.Type = TIPResolver.try_solve_initial_word(word0, word1, word2)
		if komando_type == Komando.Type.INVALID:
			# 未対応コマンド、または複数行にわたる未判定コマンドの後の行、またはただの判別不能
			paneru.komando_as_str = "?"
			paneru.komando_type = Komando.Type.INVALID
			paneru.reverse_error = "行が解釈不能: " + edit_line.line
			line_idx += 1
			continue
		elif komando_type == Komando.Type.READ_ERROR:
			paneru.komando_as_str = "error"
			paneru.komando_type = Komando.Type.READ_ERROR
			paneru.reverse_error = "読み込みエラーがあります。: " + edit_line.line
			line_idx += 1
			continue
		elif komando_type == Komando.Type.INTERP_ERROR:
			paneru.komando_as_str = "error"
			paneru.komando_type = Komando.Type.INTERP_ERROR
			paneru.reverse_error = "解釈エラーがあります。: " + edit_line.line
			line_idx += 1
			continue
		elif komando_type == Komando.Type.KOMANDO:
			# [[コマンド]]の後に、べた書きしたコマンド名が書かれている
			paneru.komando_as_str = word1
			paneru.komando_type = Komando.Type.KOMANDO
			
			edit_line.try_get_next_word() # [[コマンド]]
			edit_line.try_get_next_word() # FINALCOMBAT等
			var words: Array[String] = []
			for k in range(0, 99):
				var word: String = edit_line.try_get_next_word()
				if word == "":
					break
				words.append(word)
			var params: Array[PaneruParam] =  PaneruParam.try_parse_edit_text(words)
			for k in range(0, params.size()):
				paneru.params.append(params[k])
			line_idx += 1
			continue

		else:
			paneru.komando_type = komando_type
			paneru.komando_as_str = Komando.Type.keys()[komando_type]

		# 複数行をTIPパラメータに変換
		var tip: TIP = TIPResolver.try_create_tip_by_komando(komando_type)
		if tip == null:
			# TIP未対応コマンド
			paneru.reverse_error = "TIP未対応コマンド: " + Komando.Type.keys()[komando_type]
			line_idx += 1
			continue
		paneru.tip = tip
		var dst_error_text: Array[String] = []
		var line_idx_next: int = tip.from_edit_lines(dst_error_text, edit_lines, line_idx)
		if dst_error_text.size() > 0:
			paneru.reverse_error = dst_error_text[0]
		if line_idx_next < 0: # TIPTエラー
			line_idx += 1
			continue
		line_idx = line_idx_next

		# TIPパラメータをPaneruParamにする
		paneru.tip.reverse_into_paneru_params(paneru.params)
