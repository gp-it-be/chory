extends Node

signal money_updated(new_value: int)

var money := 1000

func _ready() -> void:
	money = 1000

func add_money(amount: int) -> void:
	money += amount
	money_updated.emit(money)
