class_name WorkingState extends HumanState
var _next_bin : Bin #TODO dont just save state like this
var _last_bin : Bin

var _task: Human.MoveTask

func work(task: Human.MoveTask):
	_task = task
	_next_bin = task.from
	print("going to ", _next_bin.name)

func __process(delta: float):
	if  _next_bin != _last_bin and _near(_next_bin): #liever met signals dan process beurt checken? =-> signals dependen wel op collision ;/
		if _next_bin == _task.from:
			_pickup_item() #TODO state machine !
		else:
			_deliver_item()
		
		_last_bin = _next_bin
		print("swtiching to ", _next_bin.name)
		_next_bin = _task.from if _next_bin == _task.to else _task.to
	_move_toward(delta)

func _pickup_item():
	var maybe_item = _task.from.pickup()
	if maybe_item != null:
		human._current_item = maybe_item
	else: 
		human.transition_to_idle()

func _deliver_item():
	_task.to.deliver(human._current_item)
	human._current_item = null
	

func _near(bin :Bin):
	return bin.global_position.distance_squared_to(global_position) < 1000

func _move_toward(delta: float):
	human.rotation = human.global_position.angle_to_point(_next_bin.global_position)
	human.position += Vector2.from_angle(human.rotation) * delta * 300
