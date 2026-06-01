extends PlayerState

@onready var attack_component: AttackComponent = %AttackComponent

@export var animation_name : String
@export var next_state : State

@export var attack : Attack
@export var attack_movement_burst : float = 10.0

var action_pressed = false

func enter(msg := {}):
	attack_component.monitoring = true
	attack_component.attack = attack
	
	player.sprite.play(animation_name)
	player.can_input = false
	action_pressed = false
	
	player.velocity.y = 0
	if msg.has("from_zero"):
		player.velocity.x = 0
		
	player.velocity.x += attack_movement_burst * player.dir_facing
	
func physics_update(delta : float):
	#if player.is_on_floor():
		#player.velocity.x = lerp(player.velocity.x, attack_movement_burst * player.dir_facing, player.quick_step * delta)
		
	if Input.is_action_just_pressed("attack"):
		action_pressed = true
		
	if player.sprite.frame == 3:
		player.ready_for_input()
		
	if next_state and player.can_input and action_pressed:
		state_machine.transition_to(next_state.name)
		
	if !player.sprite.is_playing() or player.get_input_direction() != 0.0:
		state_machine.transition_to("Idle")

func exit():
	attack_component.monitoring = false
