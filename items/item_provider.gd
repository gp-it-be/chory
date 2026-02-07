class_name ItemProvider

var _real_object: Variant:
	set(value):
		_validate_interface(value)
		_real_object = value


static func wrap(object: Variant) -> ItemProvider:
	var provider = ItemProvider.new()
	provider._real_object = object
	return provider


func pickup(amount: int) -> PickupResult:
	if _real_object.try_take(amount):
		return PickupResult.SUCCESS
	return PickupResult.FAILED
	
func item_count():
	return _real_object.count()

func wait_for_at_least_items_available(amount: int):
	await _real_object.wait_for_at_least(amount)

func _validate_interface(obj: Variant):
	get_method_list()
	var methods :Array[Dictionary]= obj.get_method_list()
	var has = methods.any(func(dic:Dictionary): return dic["name"] == "try_take" and dic["args"][0]["type"] == typeof(1))
	
	#TODO check the wait_for_at_least method
	#TODO check the count method
	##TODO extract the hasmethod
	
	assert(has, "Does not respect the interface")



enum PickupResult {
	SUCCESS,
	FAILED
}
