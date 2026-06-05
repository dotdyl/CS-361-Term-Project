extends Node2D

@onready var microservice_manager: MicroserviceManager = %MicroserviceManager

@export var note_scene : PackedScene
@export var max_notes := 10

var player : Mob

var instanced_notes : Array[Node2D]
var loaded_notes_data : Array
var ui : UIManager

var scene_name : String

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	ui = get_tree().get_first_node_in_group("ui_manager") as UIManager
	scene_name = get_tree().current_scene.name.to_lower()
	
	ui.write_note.connect(upload_note)
	
	var body = {
		"level": scene_name
	}
	
	var response = await microservice_manager.send_request(6002, "/user_notes/level", body, HTTPClient.METHOD_POST)
	print("User notes: ", response.body)
	if response.body is Array:
		loaded_notes_data = response.body
		spawn_notes()
	else:
		print("no user notes")
	
func upload_note(message : String, author : String, additional_data := {}):
	
	var body = {
		"message": message,
		"author": author,
		"level": scene_name,
		"additional_data": additional_data
	}
	var response = await microservice_manager.send_request(6002, "/user_notes", body, HTTPClient.METHOD_POST)
	print("posted!")
	
func spawn_notes():
	for note in loaded_notes_data:
		var new_note = note_scene.instantiate() as Sign
		var message = note["message"] + "\n" + "- " + note["author"]
		print(message)
		
		var body = {
			"text": message,
			"target_keywords": ["crap", "crud", "fudge"],
			"transformations": [
				"censor_keywords",
			]
		}
		
		var response = await microservice_manager.send_request(6004, "/api/text_filter", body, HTTPClient.METHOD_POST)
		print(response.body)
		
		new_note.text = response.body["filtered_text"]
		add_child(new_note)
		instanced_notes.append(new_note)
		var additional_data = note["additional_data"]
		var note_pos = Vector2(additional_data["x"], additional_data["y"])
		new_note.global_position = note_pos
		

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
