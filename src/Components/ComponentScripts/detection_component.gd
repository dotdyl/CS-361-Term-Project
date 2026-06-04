extends Node2D
class_name DetectionComponent

@export var max_distance : float
@export var vision_angle : float
@export var target_group : String
@export var vision_cone : VisionCone2D

signal detected

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	vision_cone.vision_cone_area.area_entered.connect(_area_entered)

func _area_entered(area : Area2D):
	if area is DetectableComponent:
		print("detected!")
		detected.emit({"target": area})
