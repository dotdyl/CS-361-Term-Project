extends PlayerState

func enter(msg := {}) -> void:
	if msg.has("do_jump"):
		player.velocity.y = -player.jump_impulse
		player.sprite.play("jump") # Change to jump animation


func physics_update(delta: float) -> void:
	if not is_zero_approx(player.get_input_direction()):
		player.velocity.x = lerp(player.velocity.x, player.get_input_direction() * player.speed, player.acceleration * delta)
	else:
		player.velocity.x = lerp(player.velocity.x, 0.0, player.acceleration * delta) # previously used player.air_friction
	
	player.velocity.y += player.gravity * delta
	
	if Input.is_action_just_pressed("dash"):
		state_machine.transition_to("Dash")
	elif Input.is_action_just_pressed("attack"):
		state_machine.transition_to("Attack1", {from_zero = true})
	
	if player.is_on_floor():
		if is_zero_approx(player.get_input_direction()):
			state_machine.transition_to("Idle")
		else:
			state_machine.transition_to("Run")
