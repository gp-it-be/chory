class_name Step extends RefCounted


class GoTo extends Step:
	var global_position : GlobalPosition
	
	func _init(__global_position: GlobalPosition) -> void:
		global_position = __global_position

class Pickup extends Step:
	var from : ItemProvider
	
	func _init(__from: ItemProvider) -> void:
		from = __from


class Deliver extends Step:
	var to : ItemSink
	
	func _init(__to: ItemSink) -> void:
		to = __to
