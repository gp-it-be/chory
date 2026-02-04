#TODO binnenkort bedenken hoe verschillende machines eigenschappen zullen delen
class_name Bin extends Node2D

var _item_type := ItemType.FOO

var _stock := 3

func pickup():
	if _stock >= 1:
		_stock -= 1
		debug()
		return _item_type
	return null


func deliver(type: Bin.ItemType):
	_stock += 1
	debug()

enum ItemType{
	FOO
}

func debug():
	$Debug.text = str(_stock)
