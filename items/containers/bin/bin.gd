class_name Bin extends Node2D 
#Only fits one type of item

signal stock_changed(count:int) 

var _stock = Inventory.new()

@export var start_count :int = 0

func _ready() -> void:
	_stock.stock_changed.connect(func(value):
		stock_changed.emit(value)
		$Debug.text = _stock.debug_string()
		)
	_stock.try_add(start_count, Items.ItemType.CIRCLE)
	FactoryController.register_container(self)

func as_provider():
	return ItemProvider.wrap(_stock)
	
func as_sink():
	return ItemSink.wrap(_stock)
	
func as_position():
	return GlobalPosition.wrap(self)
