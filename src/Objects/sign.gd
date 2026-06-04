extends LevelObject

@onready var interactable_component: InteractableComponent = %InteractableComponent

@export_multiline var text : String

var open : bool = false

signal read_sign

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	interactable_component.interact.connect(open_sign)
	interactable_component.exit_interaction.connect(close_sign)
	var ui_manager = get_tree().get_first_node_in_group("ui_manager") as UIManager
	read_sign.connect(ui_manager.toggle_sign.bind(text))

func close_sign():
	open = false
	read_sign.emit(open)
	
func open_sign():
	open = !open
	read_sign.emit(open)
