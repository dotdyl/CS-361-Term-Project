extends EnemyGroundState

@export var wander_time : float = 2.0
@export var wander_speed_scale : float = 0.5

var timer : SceneTreeTimer

func enter(_msg := {}):
	enemy.direction = randi_range(0, 1) * 2 - 1
	timer = get_tree().create_timer(wander_time)
	timer.timeout.connect(exit_wander)
	
	enemy.sprite.set_speed_scale(wander_speed_scale)
	enemy.sprite.play("run")
	
func physics_update(delta : float):
	enemy.velocity.x = lerp(enemy.velocity.x, enemy.speed * wander_speed_scale * enemy.direction, enemy.acceleration * delta)
	
	if enemy.direction < 0 and !enemy.edge_detector_component.left_edge:
		enemy.direction = 1.0
	if enemy.direction > 0 and !enemy.edge_detector_component.right_edge:
		enemy.direction = -1.0
	
func exit_wander():
	state_machine.transition_to("Idle")
	
func exit():
	enemy.sprite.reset_speed_scale()
	timer.timeout.disconnect(exit_wander)
