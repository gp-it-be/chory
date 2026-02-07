class_name BuyPoint extends Node2D 

signal stock_changed(count:int) 

var _stock = Inventory.new()
var _item_type := Items.ItemType.FOO



##TODO dit is nogal prototyperig. Ergens globaler de input regelen!
func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.is_pressed():
		if event.button_index == MouseButton.MOUSE_BUTTON_LEFT:
			if event.global_position.distance_squared_to(global_position) < 1000:
				$UI.show()

func _ready() -> void:
	_stock.stock_changed.connect(func(value):
		stock_changed.emit(value)
		_update_debug()
		)
	_update_debug()
	$UI.buy_requested.connect(buy)
	_stock.add(1, Items.ItemType.FOO)

func buy():
	##TODO de-prototype
	if Money.money >= 50:
		Money.add_money(-50)
		_stock.add(1, Items.ItemType.FOO)
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
	$DebugLabel.text = str(_stock.count())
