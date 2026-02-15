class_name Items


enum ItemType{
	CIRCLE,
	TRIANGLE
}


static func description_of(type) -> String:
	if type == null: return "<null>"
	if type == ItemType.CIRCLE: return "Round"
	if type == ItemType.TRIANGLE: return "Triangle"
	return "TODO"


##dont add signals on this class. it is not long lived enough since it has with_... functions
class Quantities:
	var _data: Dictionary[Items.ItemType, int] = {}
	
	func _init(dict: Dictionary[Items.ItemType, int] = {}):
		_data = dict.duplicate()
	
	func get_count(type: Items.ItemType) -> int:
		return _data.get(type, 0)
	
	func add_count(type: Items.ItemType, amount: int) -> void:
		set_count(type, get_count(type) + amount)
	
	func reduce_count(type: Items.ItemType, amount: int) -> void:
		set_count(type, get_count(type) - amount)
	
	func set_count(type: Items.ItemType, amount: int) -> void:
		_data[type] = max(0, amount)
	
	## the types with at least 1 item
	func get_types() -> Array[Items.ItemType]:
		var types: Array[Items.ItemType] = []
		for type in _data.keys():
			if _data[type] > 0:
				types.append(type)
		return types
	
	func get_values() -> Array[int]:
		var values: Array[int] = []
		for value in _data.values():
			values.append(value)
		return values
	
	func has_all(other: Quantities) -> bool:
		for type in other.get_types():
			if get_count(type) < other.get_count(type):
				return false
		return true
		
	##removes as much as possible, up to other per type.
	func remove(other: Quantities):
		for type in other.get_types():
			set_count(type, get_count(type) - other.get_count(type))
	
	func total() -> int:
		return get_values().reduce(func(accum, number): return accum + number, 0)
		
	func empty():
		return total() == 0

	func _to_string() -> String:
		var parts: Array[String] = []
		for type in get_types():
			parts.append("%s: %d" % [Items.description_of(type), get_count(type)])
		return "{%s}" % ", ".join(parts)
	
	
	##Does not mutate, rather returns a new Quantities representing the addition
	func with_added(other: Quantities) -> Quantities:
		var result = Quantities.new(_data.duplicate())
		for type in other.get_types():
			result.set_count(type, result.get_count(type) + other.get_count(type))
		return result


@abstract class ItemFilter:
	@abstract func amount_matching(counts: Items.Quantities) -> int
	
class AcceptTypes extends ItemFilter:
	var _types: Array[Items.ItemType]
	
	func _init(__types: Array[Items.ItemType]):
		_types = __types
		
	func amount_matching(counts: Items.Quantities) -> int:
		var sum = 0
		for type in counts.get_types():
			if _types.has(type):
				sum += counts.get_count(type)
		return sum
	
class AcceptAll extends ItemFilter:
	func amount_matching(counts: Items.Quantities) -> int:
		return counts.total()
