extends Node2D

@onready var progress_bar: ProgressBar = %ProgressBar
@onready var canvas_layer: CanvasLayer = %CanvasLayer

var scene_name : String = "Game/tutorial.tscn"
var scene_paths : String = "res://Scenes/"
var next_scene_path : String

var loading : bool = false
var progress : Array[float] = []

func is_loading(do : bool):
	canvas_layer.visible = do
	loading = do

func load_scene(new_scene_name : String) -> void:
	scene_name = new_scene_name
	next_scene_path = scene_paths + scene_name
	ResourceLoader.load_threaded_request(next_scene_path)
	is_loading(true)
	
func _process(delta: float) -> void:
	if !loading:
		return
	
	var status = ResourceLoader.load_threaded_get_status(next_scene_path, progress)
	
	var pct = progress[0] * 100
	progress_bar.value = pct
	match status:
		ResourceLoader.THREAD_LOAD_IN_PROGRESS:
			pass
		ResourceLoader.THREAD_LOAD_LOADED:
			var scene = ResourceLoader.load_threaded_get(next_scene_path)
			get_tree().change_scene_to_packed(scene)
			is_loading(false)
