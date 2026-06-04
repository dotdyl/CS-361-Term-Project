extends ObjectState

func enter(_msg := {}):
	
	object.sprite.flash()
	state_machine.transition_to("Idle")
