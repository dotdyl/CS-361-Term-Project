extends PlayerState

func enter(_msg := {}):
	player.sprite.play("idle")
	
func physics_update(delta: float):
	
	if not player.is_on_floor():
		state_machine.transition_to("Air")
		return
	
	player.velocity.x = lerp(player.velocity.x, 0.0, player.friction * delta)

	if Input.is_action_just_pressed("dash"):
		state_machine.transition_to("Dash")

	if Input.is_action_just_pressed("up"):
		state_machine.transition_to("Air", {do_jump = true})
	elif Input.is_action_just_pressed("attack"):
		state_machine.transition_to("Attack1", {from_zero = true})
	elif Input.is_action_just_pressed("ranged_attack"):
		state_machine.transition_to("RangedAttack")
	elif not is_zero_approx(player.get_input_direction()):
		state_machine.transition_to("Run")
