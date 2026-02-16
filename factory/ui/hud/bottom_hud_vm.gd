class_name BottomHudVM extends Node2D

signal active_task_changed(from_position: Vector2, to_position:Vector2)

var _task_from
var _task_to


var _tracked_worker: Human

func _ready() -> void:
	SignalBus.WorkerSelected.connect(_worker_selected)

func _worker_selected(worker: Human):
	print("worker selected in VM")
	if _tracked_worker:
		_tracked_worker.task_changed.disconnect(_worker_task_changed)
		_tracked_worker.task_aborted.disconnect(_worker_task_aborted)
	_tracked_worker = worker
	_task_from = null
	_task_to = null
	_emit_line_changes()
	worker.task_changed.connect(_worker_task_changed)
	worker.task_aborted.connect(_worker_task_aborted)
	worker.emit_state_signals()


func _worker_task_changed(task: Human.MoveTask):
	print("yoot 17")
	_task_from = task.from_position.get_global_position()
	_task_to = task.to_position.get_global_position()
	_emit_line_changes()
	
func _worker_task_aborted():	
	_task_from = null
	_task_to = null
	_emit_line_changes()
	
	
func _emit_line_changes():
	active_task_changed.emit(_task_from, _task_to)
