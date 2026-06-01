class_name HealthComponent
extends Area2D

@export var health : int
@export var maxHealth : int = 5

var parent : Node

signal on_death

# Called when the node enters the scene tree for the first time.
func _ready():
	health = maxHealth
	parent = get_parent()
	on_death.connect(_on_death)
	
func check_health_status():
	
	if health <= 0:
		on_death.emit()
		
func _on_death():
	print("dead")
	parent.queue_free()
	
func take_damage(attack : Attack):
	
	health -= attack.damage
	
	if health <= 0:
		print("dead")
		parent.queue_free()
