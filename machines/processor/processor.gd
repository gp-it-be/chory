class_name Processor extends Node2D


var _input = ItemHolder.new()
var _output = ItemHolder.new()


func _ready():
	update_debug()


func update_debug():
	$InputDebug.text = str(_input.count())
	$OutDebug.text = str(_output.count())
