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


class Quantities:
	var _data: Dictionary[Items.ItemType, int] = {}
	
	func _init(dict: Dictionary[Items.ItemType, int] = {}):
		_data = dict.duplicate()
	
	func get_count(type: Items.ItemType) -> int:
		return _data.get(type, 0)
	
	func set_count(type: Items.ItemType, amount: int) -> void:
		_data[type] = amount
	
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
	
	func total() -> int:
		return get_values().reduce(func(accum, number): return accum + number, 0)



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
