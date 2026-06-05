extends Node2D
class_name Campfire

@onready var interactable_component: InteractableComponent = %InteractableComponent
@onready var sprite: AnimatedSprite2D = %AnimatedSprite2D

signal lit

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	sprite.play("unlit")
	interactable_component.interact.connect(light_campfire)

func light_campfire():
	sprite.play("lit")
	lit.emit()
