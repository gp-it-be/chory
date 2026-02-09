extends Control

signal buy_requested(type :Items.ItemType)
signal close_requested

@onready var buy_round_button: Button = $PanelContainer/VBoxContainer/BuyButton
@onready var buy_triangle_button: Button = $PanelContainer/VBoxContainer/BuyTriangleButton
@onready var close_button: Button = $PanelContainer/VBoxContainer/CloseButton

func _ready() -> void:
	buy_round_button.pressed.connect(func():buy_requested.emit(Items.ItemType.CIRCLE))
	buy_triangle_button.pressed.connect(func():buy_requested.emit(Items.ItemType.TRIANGLE))
	close_button.pressed.connect(close_requested.emit)
