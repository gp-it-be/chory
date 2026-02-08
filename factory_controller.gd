class_name FactoryController extends Node2D

signal task_execution_requested(task: Human.MoveTask)
@onready var task_line: Line2D = $TaskLine
static var _instance : FactoryController
var _containers : Array = []

@onready var worker_controller: Workers = $WorkerController


func _ready():
	_instance = self
	print(null != null)

var _dragging := false
var _start_container:
	set(value):
		if _start_container != value: _start_container_updating(_start_container, value)
		_start_container = value
		
var _end_location:#:Vector2?
	set(value):
		_end_location_updating(value)
		_end_location = value 

var _end_container:
	set(value):
		#print(_end_container,"and",  value, " are equal? ", _end_container != value)
		if _end_container != value: _end_container_updating(_end_container, value)
		_end_container = value

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("select_next_worker"):
		worker_controller.select_next_worker()
	if event.is_action_pressed("abort_worker_task"):
		worker_controller.abort_worker_task()
	
	if event is InputEventMouse and event.is_action_pressed("click"):
		_start_container = _find_start_nearby(event.global_position)
		_dragging = _start_container != null
		_end_location = null
		_end_container = null
		
	if event.is_action_released("click"):
		_dragging = false
		
		if _start_container and _find_start_nearby(event.global_position) ==_start_container:
			assert(_start_container.has_method("select"), "should probably only allow selecting selectables")
			_start_container.select()
		elif _start_container and _end_container:
			assert(_start_container.has_method("as_provider") and _end_container.has_method("as_sink"), "Should probably keep containers in 2 lists and only allow starting from providers")
			task_execution_requested.emit(
				Human.MoveTask.new(_start_container.as_provider(), _end_container.as_sink(), _start_container.as_position(), _end_container.as_position())
			)
		_start_container = null
		_end_location = null
		_end_container = null
	
	if _dragging and event is InputEventMouseMotion:
		_end_container = _find_end_nearby(event.global_position)
		if _end_container:
			_end_location = _end_container.global_position
		else:
			_end_location = event.global_position

func _start_container_updating(previous, new):
	if previous:
		pass
		#print("TODO unselect start")
	if new:
		pass
		#print("TODO select start")

func _end_container_updating(previous, new):
	if previous:
		pass
		#print("TODO unselect end ")
	if new:
		pass
		#print("TODO select end ", new)
	
func _end_location_updating(new):
	if new:
		assert(_start_container != null)
		var from = _start_container.global_position
		var to = new
		_update_line(from, to)
	else:
		_clear_line()

func _clear_line():
	task_line.clear_points()

func _update_line(from: Vector2, to: Vector2):
	task_line.clear_points()
	task_line.add_point(from)
	task_line.add_point(to)

static func register_container(object):
	_instance._containers.append(object)
	
static func register_worker(worker: Human):
	_instance._worker_controller.register_worker(worker)
	
func _find_start_nearby(global_pos: Vector2):
	for container in _containers:
		if not container.has_method("as_provider"):
			"wont start from a container that isnt a provider"
			continue
		if container.global_position.distance_squared_to(global_pos) < 1000:
			return container
	return null

func _find_end_nearby(global_pos: Vector2):
	for container in _containers:
		if not container.has_method("as_sink"):
			"wont end at a container that isnt a sink"
			continue
		if container.global_position.distance_squared_to(global_pos) < 1000:
			return container
	return null
