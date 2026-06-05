extends PlayerState

@export var staggered_time : float = 0.2

var timer : SceneTreeTimer
var direction : Vector2
var knockback : float

func enter(msg := {}):
	
	player.sprite.flash()
	timer = get_tree().create_timer(staggered_time)
	timer.timeout.connect(exit_stagger)
	
	if msg.has("instant"):
		state_machine.transition_to("Idle")
	
	if msg.has("direction") && msg.has("knockback"):
		direction = msg["direction"]
		knockback = msg["knockback"]
		var knockback_dir := direction
		if direction.x > 0:
			knockback_dir = Vector2.LEFT
		elif direction.x < 0:
			knockback_dir = Vector2.RIGHT
		player.velocity += knockback * knockback_dir

func exit_stagger():
	state_machine.transition_to("Idle")

func exit():
	timer.timeout.disconnect(exit_stagger)
