extends EnemyGroundState

@export var max_chase_distance : float = 300
@export var attack_range : float = 20
@export var attack_cooldown_time : float = 1.0

var target : Node2D
var dir_to_target := Vector2.ZERO
var vector_to_target := Vector2.ZERO
var dist_to_target : float = 0.0
var x_dist_tolerance : float = 20
var still : bool = false
var just_attacked : bool = false

var attack_timer : SceneTreeTimer

func enter(msg := {}):
	if msg.has("target"):
		target = msg["target"]
	else:
		state_machine.transition_to("Idle")
		
	if just_attacked:
		attack_timer = get_tree().create_timer(attack_cooldown_time)
		attack_timer.timeout.connect(can_attack)
		
	if still:
		enemy.sprite.play("idle")
	else:
		enemy.sprite.play("run")

func physics_update(delta : float):
	
	if not enemy.is_on_floor():
		state_machine.transition_to("Air")
		return
	
	dir_to_target = lerp(dir_to_target, enemy.global_position.direction_to(target.global_position), enemy.friction * delta)
	vector_to_target = (target.global_position - enemy.global_position)
	dist_to_target = vector_to_target.length()
	
	if abs(vector_to_target.x) <= x_dist_tolerance and still == false:
		still = true
		enemy.sprite.play("idle")
	elif abs(vector_to_target.x) > x_dist_tolerance and still == true:
		still = false
		enemy.sprite.play("run")
	
	if dir_to_target.x < 0:
		enemy.direction = -1.0
	elif dir_to_target.x > 0:
		enemy.direction = 1.0
	
	if !still && !enemy.edge_detector_component.near_edge:
		enemy.velocity.x = lerp(enemy.velocity.x, enemy.direction * enemy.speed, enemy.acceleration * delta)
	else:
		enemy.velocity.x = lerp(enemy.velocity.x, 0.0, enemy.acceleration * delta)
	
	if dist_to_target > max_chase_distance && max_chase_distance != -1:
		state_machine.transition_to("Idle")
	elif dist_to_target < attack_range and !just_attacked:
		just_attacked = true
		state_machine.transition_to("Attack", {"from_zero": true, "target" : target})

func can_attack():
	just_attacked = false

func exit():
	if attack_timer:
		attack_timer.timeout.disconnect(can_attack)
