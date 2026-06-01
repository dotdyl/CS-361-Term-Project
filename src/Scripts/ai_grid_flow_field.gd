extends Node2D

@export var width : int
@export var height : int
@export var node_dist : int
@export var node_scene : PackedScene
@export var target_node : Node2D

var nodes : Array[Array]
var init : bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	for x in width:
		nodes.append([])
		for y in height:
			var pos = Vector2(x * node_dist, y * node_dist)
			var new_node = node_scene.instantiate() as AiGridFlowFieldNode
			new_node.position = pos
			new_node.i = x
			new_node.j = y
			add_child(new_node)
			nodes[x].append(new_node)
			new_node.floor_ray.force_raycast_update()
			new_node.init_node()
			new_node.flow_target = target_node
	
	for x in width:
		for y in height:
			var node = nodes[x][y] as AiGridFlowFieldNode
			if !node.active && x > 1 && x < width - 1:
				if nodes[x + 1][y].active || nodes[x - 1][y].active:
					node.edge = true
					node.debug_node.modulate = Color.YELLOW
					
	for x in width:
		for y in height:
			var node = nodes[x][y] as AiGridFlowFieldNode
			if node.edge:
				var j = y
				while j + 1 < height:
					var node_below = nodes[x][j + 1]
					if !node_below.active:
						nodes[x][j + 1].active = true
						nodes[x][j + 1].debug_node.modulate = Color.YELLOW
					else:
						break
					j += 1
