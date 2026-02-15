class_name Contract extends RefCounted

#Actualy gets emited even if an item changed that isnt part of the contract :/
signal contract_progress_changed(counts: Items.Quantities)

var _provider: ItemProvider
var needed_quantities: Items.Quantities

func _init(__provider: ItemProvider, quantities: Items.Quantities):
	_provider = __provider
	_provider.item_counts_changed.connect(contract_progress_changed.emit)
	needed_quantities = quantities
