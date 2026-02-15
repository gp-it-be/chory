class_name ContractItemTracker extends Control

signal fill_changed(is_filled:bool)

var needed : int
@onready var progress_bar: ProgressBar = %ProgressBar

var _filled:bool:
	set(value):
		if value != _filled:
			_filled = value
			fill_changed.emit(value)

func _ready():
	progress_bar.max_value = needed
	progress_bar.value = 0


func update_value(new_value):
	progress_bar.value = new_value
	_filled = new_value >= needed
