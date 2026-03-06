class_name IbentoShiito
extends RefCounted

var shiito_name: String = ""
var shiito_props: Dictionary[String, String] = {}
var panerus_props: Dictionary[String, String] = {}
var panerus: Array[Paneru] = []
var komando_to_tip_error_count: int = 0
var raw_lines: Array[IbentoFileLine] = []
