extends EnemyGroundState

@export var wander_time : float = 2.0

var timer : SceneTreeTimer

func enter(_msg := {}):
	enemy.direction = randi_range(0, 1) * 2 - 1
	timer = get_tree().create_timer(wander_time)
	timer.timeout.connect(exit_wander)
	
func physics_update(delta : float):
	enemy.velocity.x = lerp(enemy.velocity.x, enemy.speed * 0.5 * enemy.direction, enemy.acceleration * delta)
	
	if enemy.direction < 0 and !enemy.edge_detector_component.left_edge:
		enemy.direction = 1.0
	if enemy.direction > 0 and !enemy.edge_detector_component.right_edge:
		enemy.direction = -1.0
	
func exit_wander():
	state_machine.transition_to("Idle")
	
func exit():
	timer.timeout.disconnect(exit_wander)
