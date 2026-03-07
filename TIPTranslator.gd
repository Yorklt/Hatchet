class_name TIPTranslator
extends Node

# KomandoTypeとPaneruParamから、TIPテキストまで。


static func panerus_to_tip_text(dst_text: Array[String], panerus: Array[Paneru]) -> void:
	dst_text.resize(1)
	dst_text[0] = ""

	var text: String = ""
	var indent_count: int = 0
	var begin_stack: Array[Komando.Type] = []

	for i in range(0, panerus.size()):

		var paneru: Paneru =panerus[i]
		var komando_type: Komando.Type = paneru.komando_type
		var last_begin: Komando.Type = Komando.Type.INVALID
		if begin_stack.size() > 0:
			last_begin = begin_stack.back()
		var paneru_text: String = paneru.to_edit_lines(last_begin)

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

	dst_text[0] = text
