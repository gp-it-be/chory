class_name BuyPoint extends Node2D 

var _stock = Inventory.new()

func select():
	$UI.show()
	
func unselect():
	$UI.hide()

func _ready() -> void:
	_stock.stock_changed.connect(func(value):
		_update_debug()
		)
	_update_debug()
	$UI.buy_requested.connect(buy)
	$UI.close_requested.connect(unselect)
	FactoryController.register_container(self)

func buy(itemType: Items.ItemType):
	##TODO de-prototype
	if Money.money >= 50:
		if _stock.try_add_all_or_nothing(Items.Quantities.new({itemType: 1})):
			Money.add_money(-50)
		else:
			print("Couldnt buy because stock dont allow")
		
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
