class_name Human extends Node2D


var _state : HumanState

var _current_item :Enums.ItemType ##TODO do this not in Enums


func _ready():
	var states = [$Human/Idle, $Human/Working]
	for state in states:
		state.human = self
	_state = $Human/Idle
	

func give_task(from : Bin, to:Bin ):
	var task = MoveTask.new(from, to)
	_state.give_task(task)


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
	var from: Bin
	var to: Bin
	
	func _init(_from: Bin, _to: Bin):
		from = _from
		to = _to
