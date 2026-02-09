class_name Processor extends Node2D

#These should not be used directly!
var _input_pile = Inventory.new()
var _output_pile = Inventory.new()

var _input : ItemProvider = ItemProvider.wrap(_input_pile)
var _output : ItemSink = ItemSink.wrap(_output_pile)

@onready var processing: Node2D = $Processing

var _waiting := false


#TODO manier vinden om dit te doen werken zoals Working van human?
func _process(delta: float) -> void:
	if _waiting:
		return
	
	if _input.item_count() <= 0:
		_waiting = true
		await _input.wait_for_at_least_items_available(1)
		_waiting = false
		return
	
	var result = _input.pickup(1)
	if result is Inventory.TakeResultNone: return
	
	var inserted_type = (result as Inventory.TakeResultSuccess).type
	var output_type = processes_to(inserted_type)
	print("converted ", Items.description_of(inserted_type), " to ", Items.description_of(output_type))
	
	#actual processing
	_waiting = true
	$Processing/AnimationPlayer.play("process_item")
	await get_tree().create_timer(3).timeout
	var deliver_result = _output.try_deliver(output_type)
	assert(deliver_result == ItemSink.DeliverResult.SUCCESS, "Add support for sinks that get full")
	
	$Processing/AnimationPlayer.play("RESET")
	_waiting = false
	

func processes_to(type: Items.ItemType) -> Items.ItemType:
	if type == Items.ItemType.CIRCLE: return Items.ItemType.TRIANGLE
	if type == Items.ItemType.TRIANGLE: return Items.ItemType.CIRCLE
	assert(false)
	return Items.ItemType.CIRCLE

func _ready():
	update_debug()
	_input_pile.stock_changed.connect(func(_a): update_debug())
	_output_pile.stock_changed.connect(func(_a): update_debug())
	FactoryController.register_container(self)

#For the outside world, the input of the processor is where they can output the ingredients
func as_sink():
	return ItemSink.wrap(_input_pile)
	
#For the outside world, the output of the processor is where they can take the produced items
func as_provider():
	return ItemProvider.wrap(_output_pile)
	
func as_position():
	return GlobalPosition.wrap(self)

func update_debug():
	$InputDebug.text = _input_pile.debug_string()
	$OutputDebug.text = _output_pile.debug_string()
