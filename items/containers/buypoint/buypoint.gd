class_name BuyPoint extends Node2D 

signal stock_changed(count:int) 

var _stock = Inventory.new()

func select():
	$UI.show()
	
func unselect():
	$UI.hide()

func _ready() -> void:
	_stock.stock_changed.connect(func(value):
		stock_changed.emit(value)
		_update_debug()
		)
	_update_debug()
	$UI.buy_requested.connect(buy)
	$UI.close_requested.connect(unselect)
	_stock.add(1, Items.ItemType.CIRCLE)
	FactoryController.register_container(self)

func buy(itemType: Items.ItemType):
	##TODO de-prototype
	if Money.money >= 50:
		Money.add_money(-50)
		_stock.add(1, itemType)
	else:
		pass #TODO give some feedback

var _provider : ItemProvider ##mss al in de ready doen?
func as_provider() -> ItemProvider:
	if not _provider:
		_provider = ItemProvider.wrap(_stock)
	return _provider
	
func as_position():
	return GlobalPosition.wrap(self)
	
func _update_debug():
	$DebugLabel.text = _stock.debug_string()
