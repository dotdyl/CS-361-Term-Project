class_name PlayerController 
extends MobController

func _physics_process(delta: float) -> void:
	
	if Input.is_action_just_pressed("ui_accept"):
		controlVector.y = 1
		burst("controlVector:y", 0)
		
	controlVector.x = Input.get_axis("ui_left", "ui_right")
	
func burst(input: NodePath, final: float, duration: float = 0.2):
	
	var tween = create_tween()
	tween.tween_property(self, input, final, duration)
