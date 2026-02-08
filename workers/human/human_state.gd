class_name HumanState extends Node2D

var human: Human

func give_task(task :Human.MoveTask):
	pass

func __process(delta:float):
	pass

func abort_task():
	pass
	
func _accepting_tasks()-> bool:
	return false
