extends Button

func loadScene():
	print("loading tutorial")
	get_tree().change_scene_to_file("res://Scenes/Dev/testing_scene.tscn")

func _on_pressed():
	loadScene()
