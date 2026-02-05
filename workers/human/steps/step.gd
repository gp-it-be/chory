class_name Step extends RefCounted


class GoTo extends Step:
	var bin : Bin
	
	func _init(__bin: Bin) -> void:
		bin = __bin


class Pickup extends Step:
	var bin : Bin
	
	func _init(__bin: Bin) -> void:
		bin = __bin


class Deliver extends Step:
	var bin : Bin
	
	func _init(__bin: Bin) -> void:
		bin = __bin
