class_name TIPResolver
extends Node


static func try_create_tip_by_komando(paneru: Paneru) -> void:

	# TIPが増えるたびにここに付け足す
	if paneru.komando_type == Komando.Type.COMMENT:
		paneru.tip = TIP_COMMENT.new()
	if paneru.komando_type == Komando.Type.HLVARIABLE:
		paneru.tip = TIP_HLVARIABLE.new()
	if paneru.komando_type == Komando.Type.IFVARIABLE:
		paneru.tip = TIP_IFVARIABLE.new()
	if paneru.komando_type == Komando.Type.ELSE:
		paneru.tip = TIP_ELSE.new()
	if paneru.komando_type == Komando.Type.ELIF:
		paneru.tip = TIP_ELIF.new()
	if paneru.komando_type == Komando.Type.ENDIF:
		paneru.tip = TIP_ENDIF.new()
	if paneru.komando_type == Komando.Type.LOOP:
		paneru.tip = TIP_LOOP.new()
	if paneru.komando_type == Komando.Type.ENDLOOP:
		paneru.tip = TIP_ENDLOOP.new()
	if paneru.komando_type == Komando.Type.BREAK:
		paneru.tip = TIP_BREAK.new()
	if paneru.komando_type == Komando.Type.END:
		paneru.tip = TIP_END.new()
	if paneru.komando_type == Komando.Type.LABEL:
		paneru.tip = TIP_LABEL.new()
	if paneru.komando_type == Komando.Type.JUMP:
		paneru.tip = TIP_JUMP.new()
	if paneru.komando_type == Komando.Type.MESSAGE:
		paneru.tip = TIP_MESSAGE.new()
	if paneru.komando_type == Komando.Type.CHOICES:
		paneru.tip = TIP_CHOICES.new()
	if paneru.komando_type == Komando.Type.BRANCH:
		paneru.tip = TIP_BRANCH.new()
	if paneru.komando_type == Komando.Type.WAIT:
		paneru.tip = TIP_WAIT.new()
	if paneru.komando_type == Komando.Type.EXEC:
		paneru.tip = TIP_EXEC.new()
	if paneru.komando_type == Komando.Type.COMMENT_OUT:
		paneru.tip = TIP_COMMENT_OUT.new()
	if paneru.komando_type == Komando.Type.PLMOVE:
		paneru.tip = TIP_PLMOVE.new()
	if paneru.komando_type == Komando.Type.STRING_VARIABLE:
		paneru.tip = TIP_STRING_VARIABLE.new()
	if paneru.komando_type == Komando.Type.HLSTRVARIABLE:
		paneru.tip = TIP_HLSTRVARIABLE.new()
	if paneru.komando_type == Komando.Type.PLROTATE:
		paneru.tip = TIP_PLROTATE.new()
	if paneru.komando_type == Komando.Type.PLWALK:
		paneru.tip = TIP_PLWALK.new()
	if paneru.komando_type == Komando.Type.BOSSBATTLE:
		paneru.tip = TIP_BOSSBATTLE.new()
