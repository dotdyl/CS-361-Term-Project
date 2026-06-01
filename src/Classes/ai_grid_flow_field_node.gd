extends Node2D
class_name AiGridFlowFieldNode

@onready var floor_ray: RayCast2D = %RayCast2D
@export var debug_node : Node2D
@export var debug_arrow : Node2D
@export var display_debug : bool = true

var i : int = 0
var j : int = 0

var flow_target : Node2D
var flow_dir : Vector2
var active : bool = false
var edge : bool = false
var init : bool = false

func _physics_process(delta: float) -> void:
	
	var flow_target_pos = flow_target.global_position
	
	var dir_to_target = global_position.direction_to(flow_target_pos).normalized()
	var angle_to_left = dir_to_target.angle_to(Vector2.LEFT)
	var angle_to_up = dir_to_target.angle_to(Vector2.UP)
	var angle_to_right = dir_to_target.angle_to(Vector2.RIGHT)
	var angle_to_down = dir_to_target.angle_to(Vector2.DOWN)
	
	var closest = min(angle_to_left, angle_to_up, angle_to_right, angle_to_down)
	
	match closest:
		angle_to_left:
			flow_dir = Vector2.LEFT
			debug_arrow.rotation_degrees = 0
		angle_to_up:
			flow_dir = Vector2.UP
			debug_arrow.rotation_degrees = 90
		angle_to_right:
			flow_dir = Vector2.RIGHT
			debug_arrow.rotation_degrees = 180
		angle_to_down:
			flow_dir = Vector2.DOWN
			debug_arrow.rotation_degrees = -90
	
func init_node():
	debug_node.visible = display_debug
	debug_arrow.visible = display_debug
	
	if floor_ray.is_colliding():
		var collider = floor_ray.get_collider()
		if collider.get_groups().has("floor"):
			active = true
			
	if !active:
		debug_node.modulate = Color.RED
	else:
		debug_node.modulate = Color.GREEN
