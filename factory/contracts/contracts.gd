class_name ContractManager extends Node2D

@export var ui : UI
@export var contract_point : ContractPoint
var _contract_point_as_provider: ItemProvider

var _active_contracts = []

##temp logic
var time_to_contract := 1.0
var has_emitted = false

func _ready():
	_contract_point_as_provider = contract_point.as_provider()

	ui.choice_made.connect(func(choice: ContractChooser.ContractBluePrint):
		print("accepted contract for %s" % choice.name)
		var quantities: Items.Quantities = Items.Quantities.new({Items.ItemType.CIRCLE: 4, Items.ItemType.TRIANGLE: 2})
		var contract = Contract.new(_contract_point_as_provider, quantities)
		_active_contracts.append(contract)
		ui.track(contract)
		contract.emit_current_progress()
	)
	
	ui.contract_complete_requested.connect(_complete_contract)
	
func _complete_contract(contract: Contract):
	if(not _active_contracts.has(contract)): 
		push_warning("Tried to complete a contract that isnt active")
		return
	if _contract_point_as_provider.pickup_all_or_nothing(contract.needed_quantities) is Inventory.TakeResultSuccess:
		print("TODO reward player")
		_active_contracts.erase(contract)
		ui.stop_tracking(contract)
		
	




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
