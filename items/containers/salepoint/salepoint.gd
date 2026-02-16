class_name SalePoint extends Node2D 


var _sink = ItemSink.wrap(self)

func _ready() -> void:
	FactoryController.register_container(self)
	pass

func as_sink():
	return _sink
	
func as_position():
	return GlobalPosition.wrap(self)

#This is the ItemSink's try_add (make it more explicit this is a moneymachine?)
func try_add_all_or_nothing(quantities: Items.Quantities) -> bool:
	Money.add_money(quantities.total() * 100)
	return true
