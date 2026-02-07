extends Control

signal buy_requested

@onready var buy_button: Button = $PanelContainer/VBoxContainer/BuyButton
@onready var close_button: Button = $PanelContainer/VBoxContainer/CloseButton

func _ready() -> void:
	buy_button.pressed.connect(buy_requested.emit)
	close_button.pressed.connect(close)
	
func close():
	hide()
	
