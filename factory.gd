extends Node2D

@onready var bin: Bin = $Objects/Bin1
@onready var bin3: Bin = $Objects/Bin3

@onready var processor: Processor = $Objects/Processor

@onready var human: Human = $Workers/Human
@onready var human2: Human = $Workers/Human2
@onready var human3: Human = $Workers/Human3
@onready var sale_point: SalePoint = $SalePoint


func _ready() -> void:
	human.give_task(bin.as_provider(), processor.as_sink(), bin.as_position(), processor.as_position())
	human2.give_task(processor.as_provider(), bin3.as_sink(), processor.as_position(), bin3.as_position())
	human3.give_task(bin3.as_provider(), sale_point.as_sink(), bin3.as_position(), sale_point.as_position())
