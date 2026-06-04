extends Node2D

@onready var interactable_component: InteractableComponent = %InteractableComponent
@onready var sprite: AnimatedSprite2D = %AnimatedSprite2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	sprite.play("unlit")
	interactable_component.interact.connect(light_campfire)

func light_campfire():
	sprite.play("lit")
