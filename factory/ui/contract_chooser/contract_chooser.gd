class_name ContractChooser extends CenterContainer

var choices : Array[ContractBluePrint]

signal choice_made(contract_choice: ContractChooser.ContractBluePrint)
signal closed

const CONTRACT_OPTION = preload("uid://ds75y65q8g036")
var _choice_emitted := false


func _ready() -> void:
	$PanelContainer/VBoxContainer/CloseButton.pressed.connect(_on_close)
	for choice in choices:
		var instance = CONTRACT_OPTION.instantiate() as ContractOption
		instance.option = choice
		instance.choosen.connect(_choice_chosen)
		$PanelContainer/VBoxContainer/HBoxContainer.add_child(instance)

func _on_close():
	closed.emit()

func _choice_chosen(choice: ContractChooser.ContractBluePrint):
	if _choice_emitted:
		push_warning("contract choice was already made")
		return
	_choice_emitted = true
	choice_made.emit(choice)
	queue_free()


class ContractBluePrint:
	var name: String
	var reward_money: int
	
	func _init(__name: String, __reward_money: int):
		name = __name
		reward_money = __reward_money 
