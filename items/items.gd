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
