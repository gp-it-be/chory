class_name ItemProvider

signal item_counts_changed(counts: Dictionary[Items.ItemType, int])

var _real_object: Variant:
	set(value):
		_validate_interface(value)
		_real_object = value
		_real_object.stock_changed.connect(item_counts_changed.emit)


static func wrap(object: Variant) -> ItemProvider:
	var provider = ItemProvider.new()
	provider._real_object = object
	return provider


func pickup(amount: int) -> Inventory.TakeResult:
	return _real_object.try_take(amount)
	
func item_count(filter: Items.ItemFilter):
	return _real_object.count(filter)

func wait_for_at_least_items_available(amount: int, filter: Items.ItemFilter):
	await _real_object.wait_for_at_least(amount, filter)

func _validate_interface(obj: Variant):
	get_method_list()
	var methods :Array[Dictionary]= obj.get_method_list()
	var has = methods.any(func(dic:Dictionary): return dic["name"] == "try_take" and dic["args"][0]["type"] == typeof(1))
	
	#TODO check the wait_for_at_least method
	#TODO check the count method
	##TODO extract the hasmethod
	#TODO validate has signal changed
	
	assert(has, "Does not respect the interface")


#TODO no longer needed?
enum PickupResult {
	SUCCESS,
	FAILED
}
