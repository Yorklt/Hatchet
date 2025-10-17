class_name TIPResolver
extends Node


static func transcript_panels(panerus: Array[Paneru]) -> void:

	for panel_idx in range(0, panerus.size()):
		var paneru: Paneru = panerus[panel_idx]
		paneru.tip = TIPResolver.try_create_tip_by_komando(paneru.komando_type)
		if paneru.tip != null:
			paneru.tip.transcript(paneru.params)



static func try_create_tip_by_komando(komando_type: Komando.Type) -> TIP:

	# TIPが増えるたびにここに付け足す
	if komando_type == Komando.Type.COMMENT:
		return TIP_COMMENT.new()
	if komando_type == Komando.Type.HLVARIABLE:
		return TIP_HLVARIABLE.new()
	if komando_type == Komando.Type.IFVARIABLE:
		return TIP_IFVARIABLE.new()
	if komando_type == Komando.Type.ELSE:
		return TIP_ELSE.new()
	if komando_type == Komando.Type.ELIF:
		return TIP_ELIF.new()
	if komando_type == Komando.Type.ENDIF:
		return TIP_ENDIF.new()
	if komando_type == Komando.Type.LOOP:
		return TIP_LOOP.new()
	if komando_type == Komando.Type.ENDLOOP:
		return TIP_ENDLOOP.new()
	if komando_type == Komando.Type.BREAK:
		return TIP_BREAK.new()
	if komando_type == Komando.Type.END:
		return TIP_END.new()
	if komando_type == Komando.Type.LABEL:
		return TIP_LABEL.new()
	if komando_type == Komando.Type.JUMP:
		return TIP_JUMP.new()
	if komando_type == Komando.Type.MESSAGE:
		return TIP_MESSAGE.new()
	if komando_type == Komando.Type.CHOICES:
		return TIP_CHOICES.new()
	if komando_type == Komando.Type.BRANCH:
		return TIP_BRANCH.new()
	if komando_type == Komando.Type.WAIT:
		return TIP_WAIT.new()
	if komando_type == Komando.Type.EXEC:
		return TIP_EXEC.new()
	if komando_type == Komando.Type.COMMENT_OUT:
		return TIP_COMMENT_OUT.new()
	if komando_type == Komando.Type.PLMOVE:
		return TIP_PLMOVE.new()
	if komando_type == Komando.Type.STRING_VARIABLE:
		return TIP_STRING_VARIABLE.new()
	if komando_type == Komando.Type.HLSTRVARIABLE:
		return TIP_HLSTRVARIABLE.new()
	if komando_type == Komando.Type.ITEM:
		return TIP_ITEM.new()
	if komando_type == Komando.Type.PLROTATE:
		return TIP_PLROTATE.new()
	if komando_type == Komando.Type.PLWALK:
		return TIP_PLWALK.new()
	if komando_type == Komando.Type.PLMOTION:
		return TIP_PLMOTION.new()
	if komando_type == Komando.Type.ROTATE:
		return TIP_ROTATE.new()
	if komando_type == Komando.Type.WALK:
		return TIP_WALK.new()
	if komando_type == Komando.Type.MOTION:
		return TIP_MOTION.new()
	if komando_type == Komando.Type.BOSSBATTLE:
		return TIP_BOSSBATTLE.new()

	return null


# 最初の3ワードからコマンドを判断する
static func try_solve_initial_word(word0: String, word1: String, word2: String) -> Komando.Type:

	# TIPが増えるたびにここに付け足す
	if word0 == "//":
		return Komando.Type.COMMENT
	if word0 != "" and word2 != "":
		if word1 == "=" or word1 == ":=":
			return Komando.Type.HLVARIABLE
		if word1 == "+=" or word1 == ":+=":
			return Komando.Type.HLVARIABLE
		if word1 == "-=" or word1 == ":-=":
			return Komando.Type.HLVARIABLE
		if word1 == "*=" or word1 == ":*=":
			return Komando.Type.HLVARIABLE
		if word1 == "/=" or word1 == ":/=":
			return Komando.Type.HLVARIABLE
		if word1 == "mod=" or word1 == ":mod=":
			return Komando.Type.HLVARIABLE
		if word1 == "floor=" or word1 == ":floor=":
			return Komando.Type.HLVARIABLE
	if word0 == "if":
		return Komando.Type.IFVARIABLE
	if word0 == "else" or word0 == "defeated":
		return Komando.Type.ELSE
	if word0 == "endif" or word0 == "endpick" or word0 == "endex" or word0 == "endcombat" or word0 == "end???":
		return Komando.Type.ENDIF
	if word0 == "loop":
		return Komando.Type.LOOP
	if word0 == "endloop":
		return Komando.Type.ENDLOOP
	if word0 == "msg":
		return Komando.Type.MESSAGE
	if word0 == "call":
		return Komando.Type.EXEC
	if word0 == "[[コマンド]]":
		# 未対応コマンドはファイル記載のコマンドをべた書きしている
		# 例: [[コマンド]] FINALCOMBAT INT 3 FLOAT 0.2 FLOAT 0.1
		return Komando.Type.KOMANDO

	return Komando.Type.INVALID
