class_name Inventory

@export var allow_multiple_types_together: bool = false ##TODO 2 classe instead of bool?
signal stock_changed(counts: Dictionary[Items.ItemType, int])

var _counts : Dictionary[Items.ItemType, int] = {}


func try_take(amount: int) -> TakeResult:
	print("")
	print("")
	print("Starting to take ", amount)
	print("This many in total present: ", count(Items.AcceptAll.new()))
	print("Being ", _counts)
	
	if count(Items.AcceptAll.new()) >= amount:
		var total_taken = 0
		var taken : Dictionary[Items.ItemType, int]= {}
		for type in _counts:
			var type_taken = min(amount - total_taken, _counts[type])
			_counts[type] -= type_taken
			print("Took ", type_taken, " of ", type)
			if _counts[type] == 0: _counts.erase(type)
			total_taken += type_taken
			taken[type] = type_taken
			if(total_taken == amount):
				stock_changed.emit(_counts)
				return TakeResultSuccess.new(taken)
		assert(false, "cant get here")
		#print("cant get here")
		
	return TakeResultNone.new()
	
func try_add(amount: int, type: Items.ItemType) -> bool: #wether adding was succesful
	if(amount == 0): return true
	if not allow_multiple_types_together:
		if count(Items.AcceptAll.new()) != _counts.get(type, 0):
			print("Couldnt add because theres items of different type")
			return false
	_counts[type] = _counts.get_or_add(type, 0) + amount
	stock_changed.emit(_counts)
	return true	
	
func count(filter: Items.ItemFilter) -> int:
	return filter.amount_matching(_counts)

func wait_for_at_least(amount : int, filter: Items.ItemFilter):
	while true:
		var raw_dict = await stock_changed
		var counts: Dictionary[Items.ItemType, int] = {}
		for key in raw_dict.keys():
			counts[key] = raw_dict[key]
			
		if filter.amount_matching(counts) >= amount:
			return

func debug_string():
	return "%s" % _counts
	
@abstract	
class TakeResult:	
	pass
	
class TakeResultSuccess extends TakeResult:
	var counts:  Dictionary[Items.ItemType, int]
	
	func _init(__counts:  Dictionary[Items.ItemType, int]):
		counts = __counts
	
class TakeResultNone extends TakeResult:
	pass
