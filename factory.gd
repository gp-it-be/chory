extends Node2D

@onready var bin3: Bin = $Objects/Bin3

@onready var processor: Processor = $Objects/Processor

@onready var human: Human = $Workers/Human
@onready var human2: Human = $Workers/Human2
@onready var human3: Human = $Workers/Human3
@onready var sale_point: SalePoint = $SalePoint
@onready var buypoint: BuyPoint = $Buypoint

@onready var controller: FactoryController = $Controller

func _ready() -> void:
	controller.task_execution_requested.connect(_give_task_to_worker)
	
	#human.give_task(buypoint.as_provider(), processor.as_sink(), buypoint.as_position(), processor.as_position())
	#human2.give_task(processor.as_provider(), bin3.as_sink(), processor.as_position(), bin3.as_position())
	#human3.give_task(bin3.as_provider(), sale_point.as_sink(), bin3.as_position(), sale_point.as_position())

func _give_task_to_worker(task: Human.MoveTask):
	for human : Human in [human, human2, human3]:
		if human._accepting_tasks():
			human.give_task(task)
			return
	
