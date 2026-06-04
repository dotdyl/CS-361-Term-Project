class_name AttackComponent
extends Area2D

var parent : Node
var damage : float = -1
var attack : Attack

func _ready() -> void:
	var p = get_parent()
	if p is Mob: parent = p

func _on_area_entered(area):
	
	#print("Detected")
	if area is HealthComponent and area.get_parent() != parent:
		area.take_damage(attack)
