extends EnemyState

@export var staggered_time : float = 0.2

var timer : SceneTreeTimer
var direction : Vector2
var knockback : float
var attacker : Node

func enter(msg := {}):
	
	enemy.sprite.flash()
	timer = get_tree().create_timer(staggered_time)
	timer.timeout.connect(exit_stagger)
	
	if msg.has("attacker"):
		attacker = msg["attacker"]
	
	if msg.has("direction") && msg.has("knockback"):
		direction = msg["direction"]
		knockback = msg["knockback"]
		print(direction)
		var knockback_dir := Vector2.RIGHT
		if direction.x > 0:
			knockback_dir = Vector2.LEFT
		enemy.velocity += knockback * knockback_dir
		print("applying knockback!")

func exit_stagger():
	state_machine.transition_to("Chase", {"target" : attacker})

func exit():
	timer.timeout.disconnect(exit_stagger)
