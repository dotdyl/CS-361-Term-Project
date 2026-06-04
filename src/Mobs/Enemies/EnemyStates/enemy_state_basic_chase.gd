extends EnemyState

var target : Node
var dir_to_target : Vector2
var vector_to_target : Vector2
var dist_to_target : float

var still : bool = false

var x_dist_tolerance : float = 10

func enter(msg := {}):
	
	if msg.has("target"):
		target = msg["target"]
	else:
		state_machine.transition_to("Idle")
		
func physics_update(delta : float):
	
	dir_to_target = lerp(dir_to_target, enemy.global_position.direction_to(target.global_position), enemy.friction * delta)
	vector_to_target = (target.global_position - enemy.global_position)
	dist_to_target = vector_to_target.length()
	
	if abs(vector_to_target.x) <= x_dist_tolerance and still == false:
		still = true
	elif abs(vector_to_target.x) > x_dist_tolerance and still == true:
		still = false
	
	if dir_to_target.x < 0:
		enemy.direction = -1.0
	elif dir_to_target.x > 0:
		enemy.direction = 1.0
	
	if !still:
		enemy.velocity = lerp(enemy.velocity, dir_to_target * enemy.speed, enemy.acceleration * delta)
	else:
		enemy.velocity = lerp(enemy.velocity, Vector2.ZERO, enemy.acceleration * delta)
