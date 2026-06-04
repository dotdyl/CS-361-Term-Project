extends EnemyGroundState

func enter(msg := {}) -> void:
	if msg.has("do_jump"):
		enemy.velocity.y = -enemy.jump_impulse
		enemy.sprite.play("jump") # Change to jump animation

func physics_update(delta: float) -> void:

	enemy.velocity.y += enemy.gravity * delta
	
	if enemy.is_on_floor():
		state_machine.transition_to("Idle")
