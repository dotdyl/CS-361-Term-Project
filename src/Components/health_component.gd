class_name HealthComponent
extends Area2D

@export var health : int
@export var maxHealth : int = 5

var parent : Node

# Called when the node enters the scene tree for the first time.
func _ready():
	health = maxHealth
	parent = get_parent()

func adjustHealth(amt : int):
	
	health += amt
	print(health)
	
	if health <= 0:
		print("dead")
		parent.queue_free()
