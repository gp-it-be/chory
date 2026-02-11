class_name ContractOption extends PanelContainer

signal choosen(option)

var option : ContractChooser.ContractBluePrint

func _ready() -> void:
	$Panel/VBoxContainer/Button.pressed.connect(func():choosen.emit(option))
	%Label.text = option.name
	%Label2.text = str(option.reward_money)
