class_name HealthComponent
extends Area2D

@export var health : int
@export var maxHealth : int = 5
@export var queue_free_on_death : bool = false

var parent : Mob

signal damaged
signal on_death

# Called when the node enters the scene tree for the first time.
func _ready():
	health = maxHealth
	parent = get_parent() as Mob
	on_death.connect(_on_death)
	
func check_health_status():
	
	if health <= 0:
		on_death.emit()
	
func disable():
	monitorable = false

func enable():
	monitorable = true
		
func _on_death():
	print("dead")
	if queue_free_on_death:
		parent.queue_free()
	
func simple_damage(damage : int):
	
	print("taking damage!")
	damaged.emit({"attacker" : null, "direction" : Vector2.UP, "knockback" : 100})
	health -= damage
	
	if health <= 0:
		on_death.emit()
	
func take_damage(attack : Attack, attacker : Node, attack_direction : Vector2):
	
	print("taking damage!")
	damaged.emit({"attacker" : attacker, "direction" : attack_direction, "knockback" : attack.knockback})
	health -= attack.damage
	
	if health <= 0:
		on_death.emit()
