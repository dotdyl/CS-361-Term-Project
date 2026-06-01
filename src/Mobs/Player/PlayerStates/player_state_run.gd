extends PlayerState

func enter(_msg := {}) -> void:
	player.sprite.play("run")

func physics_update(delta: float) -> void:
	if not player.is_on_floor():
		state_machine.transition_to("Air")
		return
		
	if not is_zero_approx(player.get_input_direction()):
		player.velocity.x = lerp(player.velocity.x, player.get_input_direction() * player.speed, player.acceleration * delta)
	
	player.velocity.y += player.gravity * delta
	
	if Input.is_action_just_pressed("dash"):
		state_machine.transition_to("Dash")
	
	if Input.is_action_just_pressed("up"):
		state_machine.transition_to("Air", {do_jump = true})
	elif Input.is_action_just_pressed("attack"):
		state_machine.transition_to("Attack1", {from_zero = true})
	elif is_zero_approx(player.get_input_direction()):
		state_machine.transition_to("Idle")
