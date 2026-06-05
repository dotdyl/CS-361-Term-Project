extends Item

func pickup_behavior():
	var player = interactable_component.interacted_body as ControllableMob
	if player:
		var mana_component = player.get_node("ManaComponent") as ManaComponent
		if mana_component:
			mana_component.gain_mana(1)
			
	queue_free()
