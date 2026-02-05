extends Node2D

@onready var bin: Bin = $Objects/Bin1
@onready var bin2: Bin = $Objects/Bin2
@onready var bin3: Bin = $Objects/Bin3
@onready var human: Human = $Workers/Human
@onready var human2: Human = $Workers/Human2
@onready var human3: Human = $Workers/Human3


func _ready() -> void:
	human.give_task(bin, bin2)
	human2.give_task(bin2, bin3)
	human3.give_task(bin3, bin)
