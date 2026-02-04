class_name Human extends Node2D



var _state : HumanState

var _current_item #: Bin.ItemType #TODO move enum


func _ready():
	var states = [$Human/WaitingFor, $Human/Idle, $Human/Working]
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
	_state = $Human/Working
	_state.work(task)
	
	
func transition_to_idle():
	print("transition to idle")
	_state = $Human/Idle
	
class MoveTask:
	var from: Bin
	var to: Bin
	
	func _init(_from: Bin, _to: Bin):
		from = _from
		to = _to
