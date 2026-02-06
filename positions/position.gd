class_name GlobalPosition

var _real_object: Variant:
	set(value):
		_validate_interface(value)
		_real_object = value
		
func get_global_position():
	return _real_object.global_position



static func wrap(object: Variant) -> GlobalPosition:
	var position = GlobalPosition.new()
	position._real_object = object
	return position


func _validate_interface(obj: Variant):
	if not obj["global_position"]:
		push_error("BAD")

	#TODO validate that the real object is conform an interface
