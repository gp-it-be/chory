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



@abstract class ItemFilter:
	#@abstract func filter(counts: Dictionary[Items.ItemType, int]) -> Dictionary[Items.ItemType, int]
	@abstract func amount_matching(counts: Dictionary[Items.ItemType, int]) -> int
	pass
	
class AcceptTypes extends ItemFilter:
	var _types: Array[Items.ItemType]
	
	func _init(__types: Array[Items.ItemType]):
		_types = __types
		
	func amount_matching(counts: Dictionary[Items.ItemType, int]) -> int:
		var sum = 0
		for type in counts:
			if _types.has(type):
				sum += counts[type]
		return sum
	
class AcceptAll extends ItemFilter:
	func amount_matching(counts: Dictionary[Items.ItemType, int]) -> int:
		return counts.values().reduce(sum, 0)


	func sum(accum, number):
		return accum + number
