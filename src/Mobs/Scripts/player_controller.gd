class_name PlayerController 
extends MobController

var canDash : bool = true
var dash : float
var atk : float

func _physics_process(delta: float) -> void:
	
	if Input.is_action_just_pressed("up"):
		controlVector.y = 1
		burst("controlVector:y", 0)
	if Input.is_action_just_pressed("dash") and canDash:
		dash = 1.0
		canDash = false
		canDash = await burst("dash", 0, 1, 0.3)
	if Input.is_action_just_pressed("attack"):
		atk = 1.0
		burst("atk", 0)
		
	controlVector.x = Input.get_axis("left", "right")
	
func burst(input: NodePath, final: float, cooldown: float = 0.0, duration: float = 0.2) -> bool:
	
	var burstTween = create_tween()
	burstTween.tween_property(self, input, final, duration)
	
	if cooldown > 0:
		await get_tree().create_timer(cooldown).timeout
	
	return true
