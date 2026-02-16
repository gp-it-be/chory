extends Control

@export var bottom_hud_vm : BottomHudVM
@onready var line_2d: Line2D = $Line2D

func _ready() -> void:
	Money.money_updated.connect(_update_money)
	_update_money(Money.money)
	bottom_hud_vm.active_task_changed.connect(selected_worker_task_changed)
	
func _update_money(new_value: int):
	%MoneyLabel.text = "$ %d" % new_value


func selected_worker_task_changed(from_position, to_position):
	print("updating line ", from_position, " to ", to_position)
	line_2d.clear_points()
	if from_position and to_position:
		line_2d.add_point(from_position)
		line_2d.add_point(to_position)
