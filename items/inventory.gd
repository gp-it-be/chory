class_name Inventory

@export var allow_multiple_types_together: bool = false ##TODO 2 classe instead of bool?
signal stock_changed(counts: Items.Quantities)

var _counts : Items.Quantities = Items.Quantities.new()


func pickup_upto(amount: int, filter: Items.ItemFilter) -> Inventory.TakeResult:
	if _counts.empty(): return TakeResultNone.new()
	
	var still_to_take = amount
	var taken : Items.Quantities = Items.Quantities.new()
	for type in _counts.get_types():
		var type_taken = min(still_to_take, _counts.get_count(type))
		_counts.reduce_count(type, type_taken)
		print("Took ", type_taken, " of ", type)
		still_to_take -= type_taken
		taken.set_count(type, type_taken)
		if(still_to_take == 0):
			stock_changed.emit(_counts)
			return TakeResultSuccess.new(taken)
		
	return TakeResultSuccess.new(taken)
	
func try_take_all_or_nothing(to_take: Items.Quantities) -> TakeResult:
	if _counts.has_all(to_take):
		_counts.remove(to_take)
		stock_changed.emit(_counts)
		return TakeResultSuccess.new(to_take)
	return TakeResultNone.new()
	
func try_add(amount: int, type: Items.ItemType) -> bool: #wether adding was succesful
	if(amount == 0): return true
	if not allow_multiple_types_together:
		if count(Items.AcceptAll.new()) != _counts.get_count(type):
			print("Couldnt add because theres items of different type")
			return false
	_counts.set_count(type, _counts.get_count(type) + amount)
	stock_changed.emit(_counts)
	return true	
	
	
func try_add_all_or_nothing(to_add: Items.Quantities) -> bool: #wether adding was succesful
	if to_add.empty(): return true
	var added = _counts.with_added(to_add)
	if not allow_multiple_types_together:
		if added.get_types().size() > 1:
			print("Couldnt add because theres items of different type")
			return false
	_counts = added
	stock_changed.emit(_counts)
	return true	
	
func count(filter: Items.ItemFilter) -> int:
	return filter.amount_matching(_counts)

func wait_for_at_least(amount : int, filter: Items.ItemFilter):
	while true:
		var counts = await stock_changed
		if filter.amount_matching(counts) >= amount:
			return

func debug_string():
	return "%s" % _counts
	
@abstract
class TakeResult:
	pass
	
class TakeResultSuccess extends TakeResult:
	var counts: Items.Quantities
	
	func _init(__counts: Items.Quantities):
		counts = __counts
	
class TakeResultNone extends TakeResult:
	pass
