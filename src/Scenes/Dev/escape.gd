extends Area2D

var inArea : bool = false

func _input(event):
	if Input.is_action_just_pressed("escape") and inArea == true:
		
		get_tree().change_scene_to_file("res://Scenes/Menus/main_menu.tscn")


func _on_body_entered(body):
	if body is Mob:
		inArea = true

func _on_body_exited(body):
	if body is Mob:
		inArea = false
