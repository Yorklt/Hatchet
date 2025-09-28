class_name TIPEditLine
extends RefCounted

var line: String = ""
var loc: int = 0



# スペース、タブ、改行で区切られたワードを返す。
# ダブルクォーテーションで囲まれている区間は、スペースでは区切らない。
# バックスラッシュの後のダブルクォーテーションは、囲み効果はない。
# ダブルクォーテーションを除去したりはしない。
# これ以上ワードが取れないときは、""を返す。それ以外で""を返したりはしない。
func try_get_next_word(dst_is_quoted: Array[bool]) -> String:

	if dst_is_quoted != null:
		dst_is_quoted.resize(1)
		dst_is_quoted[0] = false

	# 速度を稼ぐためにここでチェック
	if loc > line.length() - 1:
		return ""

	var word: String = ""

	for n in range(0, line.length()):
		var is_finished: bool = false
		var pos0: int = -1
		var pos1: int = -1
		var found_word_end: bool = false
		var in_quote: bool = false
		var is_escapiing: bool = false
		for i in range(0, line.length()):
			loc += 1
			if loc > line.length() - 1:
				is_finished = true
				break
			var character: String = line[loc]
			if character == "\t" or character == "\n" or character == "\r":
				found_word_end = true
			elif in_quote == false and character == " ":
				found_word_end = true
			else:
				if is_escapiing == true:
					pass
				else:
					if character == "\"": # ダブルクォーテーション
						if in_quote == true:
							# 囲み終了
							in_quote = false
							if dst_is_quoted != null:
								dst_is_quoted[0] = true
						else:
							# 囲み開始
							in_quote = true
					elif character == "\\": # 円マークまたはバックスラッシュ
						is_escapiing = true

				if pos0 < 0:
					pos0 = loc
				pos1 = loc
		
			if found_word_end == true:
				break

		if pos0 >= 0 and pos1 >= 0 and pos1 >= pos0: # 1文字以上ある
			word = line.substr(pos0, pos1 - pos0 + 1)
			return word
		else:
			if is_finished == true:
				break
			else:
				continue

	return ""
