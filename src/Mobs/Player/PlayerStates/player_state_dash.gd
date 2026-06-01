extends PlayerState

@export var dash_time := 0.25

func enter(msg := {}):
	player.sprite.play("dash")
	player.velocity.y = 0
	# player.velocity.x += 200 * player.dir_facing
	get_tree().create_timer(dash_time).timeout.connect(dash_finish)

func physics_update(delta : float):
	player.velocity.x = lerp(player.velocity.x, player.dir_facing * player.speed * 5, player.acceleration * delta)

func dash_finish():
	# player.velocity.x = 0
	state_machine.transition_to("Idle")
