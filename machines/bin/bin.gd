#TODO binnenkort bedenken hoe verschillende machines eigenschappen zullen delen
class_name Bin extends Node2D 

signal stock_changed(count:int) 

var _stock = ItemHolder.new()

var _item_type := Items.ItemType.FOO

func _ready() -> void:
	_stock.stock_changed.connect(func(value):
		stock_changed.emit(value)
		$Debug.text = str(value)
		)
	_stock.add(2, _item_type)

func pickup():
	if _stock.try_take(1):
		return _item_type
	return null


func deliver(type: Items.ItemType):
	_stock.add(1, type)

func wait_for_at_least_items_available(amount: int):
	await _stock.wait_for_at_least(amount)
	
