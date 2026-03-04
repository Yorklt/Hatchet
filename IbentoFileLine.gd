class_name IbentoFileLine
extends RefCounted

var indent: int = 0
var word0: String = ""
var word1: String = ""


func to_text() -> String:
	var line: String = ""
	for k in range(0, indent):
		line += "\t"
	line += word0 + "\t" + word1
	return line
