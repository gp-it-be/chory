extends Node2D

const CONTRACT_TRACKER = preload("uid://csvkwgynk7sie")

var _inventory_provider = ItemProvider.wrap(Inventory.new())

func _ready() -> void:
	var quantities: Items.Quantities = Items.Quantities.new({Items.ItemType.CIRCLE: 4, Items.ItemType.TRIANGLE: 2})
	var contract = Contract.new(_inventory_provider, quantities)
	var trackersUI = $Factory.get_node("%ContractTrackers")
	var tracker = CONTRACT_TRACKER.instantiate()
	tracker.init_tracker(contract)
	trackersUI.add_child(tracker)
	
	var tracker2 = CONTRACT_TRACKER.instantiate()
	tracker2.init_tracker(contract)
	trackersUI.add_child(tracker2)
