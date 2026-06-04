extends LevelObject

@onready var interactable_component: InteractableComponent = %InteractableComponent

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	interactable_component.interact.connect(claim_flag)

func claim_flag():
	print("win")
