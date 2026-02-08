class_name Workers extends Node2D


var _workers: Array[Human]

var _selected_worker_index := -1
var _selected_worker = null

@onready var selection_marker: Node2D = $Selection


func _ready() -> void:
	_workers.append($Human)
	_workers.append($Human2)
	_workers.append($Human3)

##TODO dit is nogal prototyperig. Ergens globaler de input regelen?
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("select_next_worker"):
		if _selected_worker:
			selection_marker = _selected_worker.get_node("Selection")
		_selected_worker_index = wrapi(_selected_worker_index +1, 0, _workers.size())
		_selected_worker = _workers[_selected_worker_index]
		selection_marker.reparent(_selected_worker,false)
	if event.is_action_pressed("abort_worker_task"):
		_selected_worker.abort_task()
