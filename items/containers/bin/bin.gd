class_name Bin extends Node2D 

signal stock_changed(count:int) 

var _stock = Inventory.new()
var _item_type := Items.ItemType.FOO

@export var start_count :int = 0

func _ready() -> void:
	_stock.stock_changed.connect(func(value):
		stock_changed.emit(value)
		$Debug.text = str(value)
		)
	_stock.add(start_count, _item_type)

func as_provider():
	return ItemProvider.wrap(_stock)
	
func as_sink():
	return ItemSink.wrap(_stock)
	
func as_position():
	return GlobalPosition.wrap(self)
