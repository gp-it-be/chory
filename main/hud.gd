extends Control


func _ready() -> void:
	Money.money_updated.connect(_update_money)
	
	
func _update_money(new_value: int):
	$PanelContainer/HBoxContainer/Label.text = "$ %d" % new_value
	
