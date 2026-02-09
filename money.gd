class_name Money extends Node

static var singleton := Money.new()
signal _real_signal(new_value: int)
static var money_updated:= Signal(singleton._real_signal)

static var money = 1000

static func add_money(amount: int):
	money += amount
	money_updated.emit(money)
