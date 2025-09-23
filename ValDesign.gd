class_name ValDesign
extends RefCounted

enum Type
{
	LITERAL,
	HENSU,
}

var val_design_type: ValDesign.Type = ValDesign.Type.LITERAL
var chokuchi: Chokuchi = null
var hensu: Hensu = null


static func parse_paneru_params(dst_p_idx_next: Array[int], params: Array[PaneruParam], p_idx: int) -> ValDesign:

	dst_p_idx_next.resize(1)
	var vd: ValDesign = ValDesign.new()

	var param_type: PaneruParam.Type = params[p_idx].param_type
	if PaneruParam.is_type_literal(param_type) == true:
		# リテラル
		vd.val_design_type = ValDesign.Type.LITERAL
		vd.chokuchi = Chokuchi.parse_paneru_params(params, p_idx)
		p_idx += 1
	else:
		# 変数
		vd.val_design_type = ValDesign.Type.HENSU
		var dst_p_idx_next_sub: Array[int] = []
		vd.hensu = Hensu.parse_paneru_params(dst_p_idx_next_sub, params, p_idx)
		p_idx = dst_p_idx_next_sub[0]

	dst_p_idx_next[0] = p_idx
	return vd


func to_text() -> String:
	var text: String = ""
	if val_design_type == ValDesign.Type.LITERAL:
		text += chokuchi.to_text()
	else:
		text += hensu.to_text()

	return text
