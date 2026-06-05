extends Node2D
class_name Item

@onready var interactable_component: InteractableComponent = %InteractableComponent

signal pickup

func _ready() -> void:
	interactable_component.interact.connect(_on_pickup)

func spawn():
	interactable_component.set_enabled(false)
	
	var duration = 0.25
	var height = 10
	var tween = create_tween().set_parallel(true)
	var final_pos = global_position + Vector2(randi_range(-5, 5), 0)
	
	tween.tween_property(self, "global_position:x", final_pos.x, duration).set_trans(Tween.TRANS_LINEAR)
	
	var peak_height = global_position.y - height
	
	tween.tween_property(self, "global_position:y", peak_height, duration/2.0).set_trans(Tween.TRANS_QUAD)
	tween.chain().tween_property(self, "global_position:y", final_pos.y, duration/2.0).set_trans(Tween.TRANS_QUAD)
	tween.chain().tween_method(interactable_component.set_enabled, false, true, duration)

func _on_pickup():
	pickup_behavior()
	pickup.emit()
	
func pickup_behavior():
	pass
