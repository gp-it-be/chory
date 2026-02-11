class_name UI extends Control

const CONTRACT_CHOOSER = preload("uid://c318uqpiv2k6j")
signal choice_made(contract_choice: ContractChooser.ContractBluePrint)


var contract_choices: Array[ContractChooser.ContractBluePrint]:
	set(value):
		contract_choices = value
		_contract_choices_updated() 

var _chooser: ContractChooser

func _ready() -> void:
	$OpenContractsButton.pressed.connect(open_contracts)

func _contract_choices_updated():
	if _chooser:
		_chooser.queue_free()
	_chooser = CONTRACT_CHOOSER.instantiate() as ContractChooser
	_chooser.choices = contract_choices
	_chooser.visible = false
	_chooser.choice_made.connect(choice_made.emit)
	_chooser.closed.connect(func():
		_chooser.hide()
		$OpenContractsButton.show()
		)
	add_child(_chooser)
	$OpenContractsButton.show()

func open_contracts():
	$OpenContractsButton.hide()
	_chooser.visible = true
