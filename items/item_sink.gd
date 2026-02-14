class_name ItemSink

var _real_object: Variant:
	set(value):
		_validate_interface(value)
		_real_object = value
	
func try_deliver(counts: Dictionary[Items.ItemType, int]) -> DeliverResult:
	assert(counts.size() == 1, "Implement more than 1 type at once. Deliver what fits?")
	if _real_object.try_add(counts.values()[0], counts.keys()[0]):
		return DeliverResult.SUCCESS
	return DeliverResult.FAILED

func item_count():
	return _real_object.count()

static func wrap(object: Variant) -> ItemSink:
	var sink = ItemSink.new()
	sink._real_object = object
	return sink

func _validate_interface(obj: Variant):
	_assert_obj_has_method(obj, "try_add", [typeof(1), typeof(Items.ItemType.CIRCLE)], ["", "Items.ItemType"])
	
func _assert_obj_has_method(object: Variant, name: String, param_types: Array[Variant], param_type_class_names: Array[Variant]):
	var methods :Array[Dictionary]= object.get_method_list()
	assert(param_types.size() == param_type_class_names.size(), "Pass types and classes for each parameter")
	for method in methods:
		if method["name"] != name: continue
		if method["args"].size() != param_types.size(): continue
		var params_match := true
		for i in range(0,param_types.size()):
			#print(method["args"][i]["type"], " should equal ", param_types[i])
			#print(method["args"][i]["class_name"], " should equal ",param_type_class_names[i])
			if method["args"][i]["type"] != param_types[i] or method["args"][i]["class_name"] != param_type_class_names[i]: 
				params_match = false
		if not params_match: continue
		return true
	assert(false, "Does not respect the interface of method %s" % name)


enum DeliverResult {
	SUCCESS,
	FAILED
}
