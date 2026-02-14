class_name ContractManager extends Node2D

@export var ui : UI


var _active_contracts = []

##temp logic
var time_to_contract := 1.0
var has_emitted = false

func _ready():
	ui.choice_made.connect(func(choice: ContractChooser.ContractBluePrint):
		_active_contracts.append("TODO map to a class that tracks a contract by being connected to a contract inventory BIN")
		print("accepted contract for %s" % choice.name)
		)


#Temporary trigger to offer a contract choice
func _process(delta: float) -> void:
	if has_emitted: return
	time_to_contract -= delta
	if time_to_contract < 0.0:
		ui.contract_choices = _generate_contract_choices()
		has_emitted = true

func _generate_contract_choices() -> Array[ContractChooser.ContractBluePrint]:
	return [
		ContractChooser.ContractBluePrint.new("BAKERY", 100),
		ContractChooser.ContractBluePrint.new("SCHOOL", 200)
		]
