class_name Inventory

signal stock_changed(count:int) #TODO extend met itemtype?

var _count := 0

func add(amount: int, type: Items.ItemType):
	_count += amount
	stock_changed.emit(_count)

func try_take(amound: int) -> bool: #wether taking was succesful
	if _count >= amound:
		_count -= amound
		stock_changed.emit(_count)
		return true
	return false

func count() -> int:
	return  _count


func wait_for_at_least(amount : int):
	while true:
		var value = await stock_changed
		if value >= amount:
			return
