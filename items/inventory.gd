class_name Inventory
#Only fits one type of item. TODO dont call this inventory

signal stock_changed(count:int) #TODO extend met itemtype?

var _count := 0
var _current_type = null

func add(amount: int, type: Items.ItemType):
	assert(_count == 0 or _current_type == type, "cant add this type to this container")
	_count += amount
	_current_type = type
	stock_changed.emit(_count)

func try_take(amount: int) -> TakeResult:
	if _count >= amount:
		_count -= amount
		stock_changed.emit(_count)
		return TakeResultSuccess.new(amount, _current_type)
	return TakeResultNone.new()
	
func try_add(amount: int, type: Items.ItemType) -> bool: #wether adding was succesful
	if _count > 0 && _current_type != type:
		return false
	add(amount, type)
	return true

func count() -> int:
	return  _count

func wait_for_at_least(amount : int):
	while true:
		var value = await stock_changed
		if value >= amount:
			return

func debug_string():
	return "%d %s" % [_count, Items.description_of(_current_type)]
	
@abstract	
class TakeResult:	
	pass
	
class TakeResultSuccess extends TakeResult:
	var count: int
	var type: Items.ItemType
	
	func _init(__count: int, __type: Items.ItemType):
		count = __count
		type = __type
	
class TakeResultNone extends TakeResult:
	pass
