extends EnemyGroundState

@export var max_chase_distance : float = 300

var target : Node2D
var dir_to_target := Vector2.ZERO
var vector_to_target := Vector2.ZERO
var dist_to_target : float = 0.0
var x_dist_tolerance : float = 3.0
var still : bool = false

func enter(msg := {}):
	if msg.has("target"):
		target = msg["target"]

func physics_update(delta : float):
	
	dir_to_target = lerp(dir_to_target, enemy.global_position.direction_to(target.global_position), enemy.friction * delta)
	vector_to_target = (target.global_position - enemy.global_position)
	dist_to_target = vector_to_target.length()
	
	if abs(vector_to_target.x) < x_dist_tolerance:
		still = true
	else:
		still = false
	
	if dir_to_target.x < 0:
		enemy.direction = -1.0
	elif dir_to_target.x > 0:
		enemy.direction = 1.0
	
	if !still:
		enemy.velocity.x = lerp(enemy.velocity.x, enemy.direction * enemy.speed, enemy.acceleration * delta)
	else:
		enemy.velocity.x = lerp(enemy.velocity.x, 0.0, enemy.acceleration * delta)
	
	if dist_to_target > max_chase_distance && max_chase_distance != -1:
		state_machine.transition_to("Idle")
