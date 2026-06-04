extends PlayerState

const FIREBALL = preload("res://Items/fireball.tscn")

@export var mana_component : ManaComponent

func enter(_msg := {}):
	if mana_component.mana > 0:
		mana_component.consume_mana(1)
		var fireball = FIREBALL.instantiate()
		get_tree().current_scene.call_deferred("add_child", fireball)
		fireball.global_position = player.global_position - Vector2(0, 8)
		fireball.direction.x = player.dir_facing
		fireball.origin = player
	state_machine.transition_to("Idle")
