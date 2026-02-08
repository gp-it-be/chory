class_name WorkingState extends HumanState

var _aborted := false
var _steps: Array[Step]
var _current_step : Step
var _current_step_index: int:
	set(value):
		_current_step_index = value
		_current_step = _steps[value]
		
var _current_step_paused := false #The current step is paused, and it will set this flag to false when unpaused by itself

func abort_task():
	_aborted = true
	human.transition_to_idle()

func work(task: Human.MoveTask):
	_aborted = false
	_steps = [
		Step.GoTo.new(task.from_position), 
		Step.Pickup.new(task.from),
		Step.GoTo.new(task.to_position), 
		Step.Deliver.new(task.to)
	]
	_current_step_index = 0


func __process(delta: float):
	if _aborted or _current_step_paused: return
	
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
			##TODO verify the current step is still the same (maybe some GUID?)
			#during wait this could have been aborted and then given a new state
			#ORR: recreate state node?
			_current_step_paused = false
		return picked_up

	push_error("cant get here atm, but gdscript doesnt know, and wont tell me when we can.")
	return false


func _pickup_item(from:ItemProvider):
	var maybe_item = from.pickup(1)
	if maybe_item == ItemProvider.PickupResult.SUCCESS:
		human.inventory.add(1,maybe_item)
		return true
	else: 
		return false

func _deliver_item(to: ItemSink):
	if not human.inventory.try_take(1):
		push_error("how the fuck did we get here without an item?")
	var result = to.try_deliver(Items.ItemType.FOO) #TODO change at some point
	assert(result == ItemSink.DeliverResult.SUCCESS, "Add support for sinks that get full")
	

func _near(global :GlobalPosition):
	return global.get_global_position().distance_squared_to(global_position) < 1000

func _move_toward(global:GlobalPosition, delta: float):
	human.rotation = human.global_position.angle_to_point(global.get_global_position())
	human.position += Vector2.from_angle(human.rotation) * delta * 300
