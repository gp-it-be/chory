class_name ContractTracker extends PanelContainer

signal contract_complete_requested()

const CONTRACT_ITEM_TRACKER = preload("uid://cpofhyjebgxkt")

var _item_trackers: Dictionary[Items.ItemType, ContractItemTracker] ={}
var _filled_states: Dictionary[Items.ItemType, bool] = {}
#var _contract: Contract

func _ready():
	%CompleteButton.pressed.connect(func(): contract_complete_requested.emit())

func init_tracker(contract:Contract):
	#_contract = contract
	for type in contract.needed_quantities.get_types():
		var item_tracker = CONTRACT_ITEM_TRACKER.instantiate() as ContractItemTracker
		item_tracker.needed = contract.needed_quantities.get_count(type)
		%ContractTracker.add_child(item_tracker)
		_item_trackers[type] = item_tracker
		_filled_states[type] = false
		item_tracker.fill_changed.connect(func(is_filled):_update(type, is_filled))
		
	contract.contract_progress_changed.connect(func(values: Items.Quantities):
		for type in _item_trackers:
			_item_trackers[type].update_value(values.get_count(type))
	)
	
func _update(type: Items.ItemType, is_filled: bool):
	_filled_states[type] = is_filled
	var can_complete = _filled_states.values().all(func(value): return value)
	%CompleteButton.visible = can_complete
