extends Mob
class_name ControllableMob

var can_input := true

func get_input_direction() -> float:
	if !can_input:
		return 0.0
	
	direction = Input.get_action_strength("right") - Input.get_action_strength("left")
	return direction

func ready_for_input():
	can_input = true
