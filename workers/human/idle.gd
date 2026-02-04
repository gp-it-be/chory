class_name IdleSate extends HumanState

func __process(delta: float) -> void:
	pass
	
func give_task(task :Human.MoveTask):
	human.transition_to_working(task)
