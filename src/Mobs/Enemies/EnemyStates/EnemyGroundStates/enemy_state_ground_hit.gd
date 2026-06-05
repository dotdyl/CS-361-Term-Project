extends EnemyGroundState

@export var staggered_time : float = 0.2
@export var retaliate : bool = true

var attacker : Node
var direction : Vector2
var knockback : float

var timer : SceneTreeTimer

func enter(msg := {}):
	
	enemy.sprite.play("jump")
	enemy.sprite.flash()
	timer = get_tree().create_timer(staggered_time)
	timer.timeout.connect(exit_stagger)
	
	if msg.has("attacker"):
		attacker = msg["attacker"]
	
	if msg.has("direction") && msg.has("knockback"):
		direction = msg["direction"]
		knockback = msg["knockback"]
		var knockback_dir := Vector2.RIGHT
		if direction.x > 0:
			knockback_dir = Vector2.LEFT
		enemy.velocity += knockback * knockback_dir

func exit_stagger():
	
	if attacker:
		state_machine.transition_to("Chase", {"target" : attacker})
	else:
		state_machine.transition_to("Idle")

func exit():
	timer.timeout.disconnect(exit_stagger)
