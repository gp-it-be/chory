extends Node2D

@onready var bin: Bin = $Objects/Bin1
@onready var bin2: Bin = $Objects/Bin2
@onready var human: Human = $Workers/Human


func _ready() -> void:
	human.give_task(bin, bin2)
