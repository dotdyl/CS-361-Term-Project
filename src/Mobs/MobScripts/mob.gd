class_name Mob
extends CharacterBody2D

@onready var sprite: CompositeAnimatedSprite2D = %CompositeAnimatedSprite2D

@export var nodes_to_flip_pos : Array[Node2D]
@export var nodes_to_flip_rot : Array [Node2D]

@export var speed = 80
@export var jump_impulse = 360
@export var gravity = 1200
@export var acceleration = 60
@export var friction = 20
@export var air_friction = 5
@export var quick_step = 100

var dir_facing : float = 1.0
var direction : float = 0.0

func _physics_process(delta: float):
		
	if direction < 0:
		sprite.flip_h(true)
		dir_facing = -1.0
		for node in nodes_to_flip_pos:
			if node.position.x > 0:
				node.position.x *= -1
		for node in nodes_to_flip_rot:
			if node.rotation_degrees < 0:
				node.rotation *= -1
	if direction > 0:
		sprite.flip_h(false)
		dir_facing = 1.0
		for node in nodes_to_flip_pos:
			if node.position.x < 0:
				node.position.x *= -1
		for node in nodes_to_flip_rot:
			if node.rotation_degrees > 0:
				node.rotation *= -1
	
	move_and_slide()
