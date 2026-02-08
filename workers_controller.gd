class_name Workers extends Node2D

var _workers: Array[Human]
var _selected_worker_index := -1
var _selected_worker = null

@onready var selection_marker: Node2D = $Selection

func register_worker(worker: Human) -> void:
	_workers.append(worker)

func abort_worker_task():
	if _selected_worker:
		_selected_worker.abort_task()
	
func assign_task(task: Human.MoveTask):
	for human in _workers:
		if human._accepting_tasks():
			human.give_task(task)
			return
	
func select_next_worker():
	if _selected_worker:
		selection_marker = _selected_worker.get_node("Selection")
	_selected_worker_index = wrapi(_selected_worker_index +1, 0, _workers.size())
	_selected_worker = _workers[_selected_worker_index]
	selection_marker.reparent(_selected_worker,false)
