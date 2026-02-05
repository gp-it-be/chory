class_name WorkingState extends HumanState

var _steps: Array[Step]
var _current_step : Step
var _current_step_index: int:
	set(value):
		_current_step_index = value
		_current_step = _steps[value]
		
var _current_step_paused := false #The current step is paused, and it will set this flag to false when unpaused by itself

func work(task: Human.MoveTask):
	_steps = [
		Step.GoTo.new(task.from), 
		Step.Pickup.new(task.from),
		Step.GoTo.new(task.to), 
		Step.Deliver.new(task.to)
	]
	_current_step_index = 0


func __process(delta: float):
	if _current_step_paused: return
	
	if await process_finishes_current_step(delta):
		_current_step_index = wrapi(_current_step_index +1, 0, _steps.size())

func process_finishes_current_step(delta: float) -> bool:
	if _current_step is Step.GoTo:
		var _goto = _current_step as Step.GoTo
		_move_toward(_goto.bin, delta)
		return _near(_goto.bin)

	if _current_step is Step.Deliver:
		var _deliver = _current_step as Step.Deliver
		_deliver_item(_deliver.bin)
		return true

	if _current_step is 	Step.Pickup:
		var _pickup = _current_step as Step.Pickup
		var picked_up = _pickup_item(_pickup.bin)
		if not picked_up:
			_current_step_paused = true
			await _pickup.bin.wait_for_at_least_items_available(1)
			_current_step_paused = false
		return picked_up

	push_error("cant get here atm, but gdscript doesnt know, and wont tell me when we can.")
	return false


func _pickup_item(from:Bin):
	var maybe_item = from.pickup()
	if maybe_item != null:
		human._inventory.add(1,maybe_item)
		return true
	else: 
		return false

func _deliver_item(to: Bin):
	if not human._inventory.try_take(1):
		push_error("how the fuck did we get here without an item?")
	to.deliver(Items.ItemType.FOO) #TODO change at some point
	

func _near(bin :Bin):
	return bin.global_position.distance_squared_to(global_position) < 1000

func _move_toward(bin:Bin, delta: float):
	human.rotation = human.global_position.angle_to_point(bin.global_position)
	human.position += Vector2.from_angle(human.rotation) * delta * 300
