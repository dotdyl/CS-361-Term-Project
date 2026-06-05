extends Node
class_name GameManager

@export var tile_map : TileMapLayer

var player : Mob
var ui : UIManager
var microservice_manager : MicroserviceManager

var scene_name : String

var checkpoints : Array = []
var last_checkpoint := -1

var level_data := {}
var player_data := {}

func _ready() -> void:
	player = get_tree().get_first_node_in_group("ally")
	(player.get_node("HealthComponent") as HealthComponent).on_death.connect(game_over)
	
	ui = get_tree().get_first_node_in_group("ui_manager") as UIManager
	microservice_manager = get_tree().get_first_node_in_group("microservice_manager") as MicroserviceManager
	
	checkpoints = get_tree().get_nodes_in_group("checkpoint") as Array[Campfire]
	checkpoints.sort()
	print(checkpoints)
	for c in checkpoints:
		c.lit.connect(_add_checkpoint.bind(checkpoints.find(c)))
	
	init_player_data()
	
func init_player_data():
	var response = await microservice_manager.send_request(6001, "/user_analytics")
	player_data = response.body
	
	scene_name = get_tree().current_scene.name.to_lower()
	
	if player_data.has("level_data"):
		var all_level_data = player_data["level_data"]
		for level in all_level_data:
			if level == scene_name:
				print("Current scene data in user data")
				level_data = all_level_data[level]
				print(level_data)
				if level_data.has("last_checkpoint"):
					print("loading checkpoint")
					last_checkpoint = level_data["last_checkpoint"]
					reset_to_checkpoint()
	
func reset_to_checkpoint():
	if last_checkpoint != -1:
		player.global_position = checkpoints[last_checkpoint].global_position
	
func _add_checkpoint(idx : int):
	print("Adding checkpoint at index ", idx)
	if idx > last_checkpoint:
		last_checkpoint = idx
		var body = {
			"level_data" : {
				scene_name : {
					"last_checkpoint" : last_checkpoint
				}
			}
		}
		var response = await microservice_manager.send_request(6001, "/user_analytics/set", body, HTTPClient.METHOD_POST)
		print(response)
	
func game_over():
	print("game over")
	ui.toggle_game_over(true)
	var body = {
		"add" : {"total_deaths" : 1}
	}
	var response = await microservice_manager.send_request(6001, "/user_analytics", body, HTTPClient.METHOD_POST)
