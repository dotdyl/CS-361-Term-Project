extends Node2D

@onready var sprite: AnimatedSprite2D = %AnimatedSprite2D
@onready var attack_component: AttackComponent = %AttackComponent

@export var speed := 100.0

var origin : Node

var direction := Vector2.ZERO

func _ready():
	if direction.x > 0:
		sprite.flip_h = false
	else:
		sprite.flip_h = true

func _physics_process(delta: float) -> void:
	global_position.x += speed * delta * direction.x
