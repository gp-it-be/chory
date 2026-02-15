class_name Inventory

@export var allow_multiple_types_together: bool = false ##TODO 2 classe instead of bool?
signal stock_changed(counts: Items.Quantities)

var _counts : Items.Quantities = Items.Quantities.new()

func try_take(amount: int) -> TakeResult:
	print("")
	print("")
	print("Starting to take ", amount)
	print("This many in total present: ", count(Items.AcceptAll.new()))
	print("Being ", _counts)
	
	if count(Items.AcceptAll.new()) >= amount:
		var total_taken = 0
		var taken : Items.Quantities = Items.Quantities.new()
		for type in _counts.get_types():
			var type_taken = min(amount - total_taken, _counts.get_count(type))
			_counts.set_count(type, _counts.get_count(type) - type_taken)
			print("Took ", type_taken, " of ", type)
			total_taken += type_taken
			taken.set_count(type, type_taken)
			if(total_taken == amount):
				stock_changed.emit(_counts)
				return TakeResultSuccess.new(taken)
		assert(false, "cant get here")
		
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
