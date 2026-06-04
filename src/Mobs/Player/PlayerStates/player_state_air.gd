extends PlayerState

@export var coyote_time : float = 0.2

var can_jump : bool = false
var coyote_timer : SceneTreeTimer

func enter(msg := {}) -> void:
	if msg.has("do_jump"):
		player.velocity.y = -player.jump_impulse
		player.sprite.play("jump") # Change to jump animation
		can_jump = false
	elif coyote_time > 0:
		coyote_timer = get_tree().create_timer(coyote_time)
		coyote_timer.timeout.connect(disable_jump)
		can_jump = true

func physics_update(delta: float) -> void:
	if not is_zero_approx(player.get_input_direction()):
		player.velocity.x = lerp(player.velocity.x, player.get_input_direction() * player.speed, player.acceleration * delta)
	else:
		player.velocity.x = lerp(player.velocity.x, 0.0, player.acceleration * delta) # previously used player.air_friction
	
	player.velocity.y += player.gravity * delta
	
	if Input.is_action_just_pressed("up") && can_jump == true:
		state_machine.transition_to("Air", {"do_jump" : true})
	elif Input.is_action_just_pressed("dash"):
		state_machine.transition_to("Dash")
	elif Input.is_action_just_pressed("attack"):
		state_machine.transition_to("Attack1", {from_zero = true})
	elif Input.is_action_just_pressed("ranged_attack"):
		state_machine.transition_to("RangedAttack")
	
	if player.is_on_floor():
		if is_zero_approx(player.get_input_direction()):
			state_machine.transition_to("Idle")
		else:
			state_machine.transition_to("Run")

func disable_jump():
	can_jump = false
