extends EnemyGroundState

@onready var attack_component: AttackComponent = %AttackComponent

@export var attack : Attack
@export var animation_name : String
@export var attack_movement_burst : float = 10
@export var combo_chance : float = 50
@export var next_state : State

var target : Node

func enter(msg := {}):
	attack_component.attack = attack
	attack_component.enable()
	
	enemy.sprite.play(animation_name)
	
	enemy.velocity.y = 0
	if msg.has("from_zero"):
		enemy.velocity.x = 0
	if msg.has("target"):
		target = msg["target"]
		
	enemy.velocity.x += attack_movement_burst * enemy.dir_facing
	
func physics_update(delta : float):
		
	var do_combo := randi_range(0, 100)
		
	if next_state and do_combo <= combo_chance:
		state_machine.transition_to(next_state.name)	
	elif !enemy.sprite.is_playing():
		state_machine.transition_to("Chase", {"target" : target})

func exit():
	attack_component.disable()
