class_name AttackComponent
extends Area2D

@export var auto_attack_timer : Timer
@export var attack : Attack
@export var one_shot : bool = false
@export var projectile : bool = false

var parent : Node
var damage : float = -1
var enabled : bool = false
var hit_nodes : Array[HealthComponent]

func _ready() -> void:
	
	if projectile:
		enable()
	parent = get_parent()
	
	if auto_attack_timer:
		auto_attack_timer.timeout.connect(_auto_attack)

func _on_area_entered(area):
	if projectile: print("fireball area entered")
	var direction
	if !projectile:
		direction = (parent.global_position - area.global_position).normalized()
	else:
		direction = (global_position - area.global_position).normalized()
	if area is HealthComponent and area.get_parent() != parent and !hit_nodes.has(area):
		hit_nodes.append(area)
		area.take_damage(attack, parent, direction)
		if one_shot:
			parent.queue_free()

func _auto_attack():
	if enabled: disable()
	else: enable()

func disable():
	enabled = false
	monitoring = false
	hit_nodes.clear()
	
func enable():
	enabled = true
	monitoring = true
