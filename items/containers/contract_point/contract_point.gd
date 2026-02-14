class_name ContractPoint extends Node2D 

signal stock_changed(count:int) 

var _stock = Inventory.new()

func _ready() -> void:
	_stock.allow_multiple_types_together = true
	_stock.stock_changed.connect(func(value):
		stock_changed.emit(value)
		_update_debug()
		)
	_update_debug()
	FactoryController.register_container(self)


func as_sink() -> ItemSink:
	return ItemSink.wrap(_stock)
	
func as_provider() -> ItemProvider:
	return ItemProvider.wrap(_stock)	

func as_position():
	return GlobalPosition.wrap(self)
	
func _update_debug():
	$DebugLabel.text = _stock.debug_string()
