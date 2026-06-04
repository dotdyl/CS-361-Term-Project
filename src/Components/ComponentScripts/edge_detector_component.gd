extends Node2D
class_name EdgeDetectorComponent

var edge_detector_left : RayCast2D
var edge_detector_right : RayCast2D

var near_edge : bool
var left_edge : bool
var right_edge : bool

func _ready():
	for child in get_children():
		if child is RayCast2D:
			if child.name.to_lower().contains("left"):
				edge_detector_left = child
			elif child.name.to_lower().contains("right"):
				edge_detector_right = child
				
func _physics_process(delta: float):
	
	left_edge = edge_detector_left.is_colliding()
	right_edge = edge_detector_right.is_colliding()
	
	if !left_edge || !right_edge:
		near_edge = true
	else:
		near_edge = false
