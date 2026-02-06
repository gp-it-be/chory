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
		Step.GoTo.new(task.from_position), 
		Step.Pickup.new(task.from),
		Step.GoTo.new(task.to_position), 
		Step.Deliver.new(task.to)
	]
	_current_step_index = 0


func __process(delta: float):
	if _current_step_paused: return
	
	if await process_finishes_current_step(delta):
		_current_step_index = wrapi(_current_step_index +1, 0, _steps.size())

func process_finishes_current_step(delta: float) -> bool:
	if _current_step is Step.GoTo:
		var step = _current_step as Step.GoTo
		_move_toward(step.global_position, delta)
		return _near(step.global_position)

	if _current_step is Step.Deliver:
		var step = _current_step as Step.Deliver
		_deliver_item(step.to)
		return true

	if _current_step is Step.Pickup:
		var step = _current_step as Step.Pickup
		var picked_up = _pickup_item(step.from)
		if not picked_up:
			_current_step_paused = true
			await step.from.wait_for_at_least_items_available(1)
			_current_step_paused = false
		return picked_up

	push_error("cant get here atm, but gdscript doesnt know, and wont tell me when we can.")
	return false


func _pickup_item(from:ItemProvider):
	var maybe_item = from.pickup(1)
	if maybe_item == ItemProvider.PickupResult.SUCCESS:
		human._inventory.add(1,maybe_item)
		return true
	else: 
		return false

func _deliver_item(to: ItemSink):
	if not human._inventory.try_take(1):
		push_error("how the fuck did we get here without an item?")
	to.deliver(Items.ItemType.FOO) #TODO change at some point
	

func _near(global :GlobalPosition):
	return global.get_global_position().distance_squared_to(global_position) < 1000

func _move_toward(global:GlobalPosition, delta: float):
	human.rotation = human.global_position.angle_to_point(global.get_global_position())
	human.position += Vector2.from_angle(human.rotation) * delta * 300
