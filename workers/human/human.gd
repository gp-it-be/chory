class_name Human extends Node2D


var _state : HumanState
var inventory = Inventory.new()

func _ready():
	var states = [$Human/Idle, $Human/Working]
	for state in states:
		state.human = self
	_state = $Human/Idle

#Not satisfied with ItemProvider and GlobalPosition being passed seperatly
#Hoping I'll discover a way to improve this
func give_task(task: MoveTask):	
	_state.give_task(task)

func _accepting_tasks()-> bool:
	return _state._accepting_tasks()
	
func abort_task():
	_state.abort_task()

func _process(delta: float) -> void:
	_state.__process(delta)

func transition_to_working(task: MoveTask):
	print("transition to working")
	_state = $Human/Working as WorkingState
	_state.work(task)
	
func continue_work():
	_state = $Human/Working as WorkingState
	
func transition_to_idle():
	print("transition to idle")
	_state = $Human/Idle	
	
class MoveTask:
	var from: ItemProvider
	var to: ItemSink
	var from_position: GlobalPosition
	var to_position: GlobalPosition
	
	func _init(_from: ItemProvider, _to: ItemSink, _from_position: GlobalPosition, _to_position:GlobalPosition):
		from = _from
		to = _to
		from_position = _from_position
		to_position = _to_position
