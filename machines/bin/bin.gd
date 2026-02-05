#TODO binnenkort bedenken hoe verschillende machines eigenschappen zullen delen
class_name Bin extends Node2D

signal restocked() #when was empty and no longer is

var _item_type := Items.ItemType.FOO

var _stock := 2

func pickup():
	if _stock >= 1:
		_stock -= 1
		debug()
		return _item_type
	return null


func deliver(type: Items.ItemType):
	_stock += 1
	if _stock == 1:
		restocked.emit()
	debug()


func debug():
	$Debug.text = str(_stock)
