class_name AttackComponent
extends Area2D

var parent : Node

func _ready() -> void:
	var p = get_parent()
	if p is Mob: parent = p

func emitAttack(atk : Attack, hth : HealthComponent):
	
	print("Attack")
	hth.adjustHealth(atk.damage)


func _on_area_entered(area):
	
	#print("Detected")
	if area is HealthComponent and area.get_parent() != parent:
		var newAtk = Attack.new()
		newAtk.damage = -1
		emitAttack(newAtk, area)
