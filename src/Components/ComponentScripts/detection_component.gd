extends Node2D
class_name DetectionComponent

@export var target_group : String
@export var vision_cone : VisionCone2D

signal detected

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	vision_cone.vision_cone_area.area_entered.connect(_area_entered)

func _area_entered(area : Area2D):
	var parent = area.get_parent()
	var groups = parent.get_groups()
	if area is DetectableComponent and groups.size() != 0 and groups.has("ally"):
		detected.emit({"target": area})
