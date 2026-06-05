extends PlayerState

@export var tile_map_detector : TileMapDetector
@export var target_data := "two_way"
@export var y_dist : float = 20

var start_y := 0

func enter(_msg := {}):
	var cell_data = tile_map_detector.get_tile_map_cell(Vector2(0, 16), false)
	if cell_data.has_custom_data("two_way"):
		if cell_data.get_custom_data("two_way") == true:
			start_y = player.global_position.y
			player.collision_shape_2d.disabled = true
			player.velocity.y += player.gravity / 7.0
		else:
			state_machine.transition_to("Idle")
	else:
		state_machine.transition_to("Idle")
	
func physics_update(_delta: float) -> void:
	
	if abs(player.global_position.y - start_y) > y_dist:
		state_machine.transition_to("Air")
		
func exit():
	player.collision_shape_2d.disabled = false
