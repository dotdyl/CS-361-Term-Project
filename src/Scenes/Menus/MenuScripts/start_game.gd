extends Button

func loadScene():
	Loading.load_scene("Game/tutorial.tscn")

func _on_pressed():
	loadScene()
