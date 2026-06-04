extends EnemyGroundState

@export var idle_time : float = 2.0

var timer : SceneTreeTimer

func enter(_msg := {}):
	timer = get_tree().create_timer(idle_time)
	timer.timeout.connect(exit_idle)
	
	enemy.sprite.play("idle")
	
func physics_update(delta : float):
	
	if not enemy.is_on_floor():
		state_machine.transition_to("Air")
		return
	
	enemy.velocity.x = lerp(enemy.velocity.x, 0.0, enemy.friction * delta)
	
func exit_idle():
	state_machine.transition_to("Wander")
	
func exit():
	timer.timeout.disconnect(exit_idle)
