extends PlayerState

@onready var ui_manager : UIManager = %CanvasLayer

func enter(_msg := {}):
	player.velocity = Vector2.ZERO
	player.can_input = false
	ui_manager.toggle_note_writing(true)
	
func physics_update(_delta : float):
	
	if Input.is_action_just_pressed("escape") || ui_manager.write_note_panel.visible == false:
		state_machine.transition_to("Idle")
	
func exit():
	ui_manager.toggle_note_writing(false)
	player.can_input = true
