class_name Joken
extends Node

enum Type
{
	INVALID,
	COND_TYPE_VARIABLE,
	COND_TYPE_ARRAY_VAR,
	COND_TYPE_SWITCH,
	COND_TYPE_ARRAY_SW,	
}

var joken_type: Joken.Type = Joken.Type.INVALID
var operator: int = 0
var index: int = 0
var option: int = 0
var rokaru_ref: bool = false
var pointa: int = -1
var pointa_name: String = ""
var ref_name: String = ""


# operator: 選択肢パネルでは常にイコール
# index: 謎の値
# option: 右辺値
# rokaru_ref:
#   条件タイプが非配列変数の場合、扱う変数がローカル。
#   配列変数の場合、添え字の変数がローカル。うわー。
# pointa: 配列で添え字がリテラルの場合に使用、それ以外は-1
# pointa_name: 配列で添え字が変数の場合に使用、それ以外は""
# ref_name: 変数名。セーブ間共有変数は「通常変数」と区別が付かない
# （名前が重複できないのでおそらく、どこか別の場所で、セーブ間変数は通常変数の特別版として管理されているようだ）。
