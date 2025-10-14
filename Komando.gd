class_name Komando
extends RefCounted

enum Type
{
	INVALID,
	KOMANDO, # べた書き
	COMMENT,
	HLVARIABLE,
	IFVARIABLE,
	ELSE,
	ELIF,
	ENDIF,
	LOOP,
	ENDLOOP,
	BREAK,
	END,
	LABEL,
	JUMP,
	MESSAGE,
	CHOICES,
	BRANCH,
	WAIT,
	EXEC,
	COMMENT_OUT,
	PLMOVE,
	STRING_VARIABLE,
	HLSTRVARIABLE,
	ITEM,
	PLROTATE,
	PLWALK,
	PLMOTION,
	ROTATE,
	WALK,
	MOTION,
	BOSSBATTLE,
}

static func parse_file_text(text: String) -> Komando.Type:
	for i in range(0, Komando.Type.keys().size()):
		if text == Komando.Type.keys()[i]:
			return Komando.Type.values()[i] as Komando.Type
	return Komando.Type.INVALID
