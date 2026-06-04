extends PlayerState

@onready var health_component: HealthComponent = %HealthComponent

@export var dash_time := 0.25

func enter(msg := {}):
	player.sprite.play("dash")
	player.velocity.y = 0
	player.set_collision_mask_value(1, false)
	get_tree().create_timer(dash_time).timeout.connect(dash_finish)
	
	health_component.disable()

func physics_update(delta : float):
	player.velocity.x = lerp(player.velocity.x, player.dir_facing * player.speed * 5, player.acceleration * delta)

func dash_finish():
	state_machine.transition_to("Idle")
	
func exit():
	health_component.enable()
	player.set_collision_mask_value(1, true)
