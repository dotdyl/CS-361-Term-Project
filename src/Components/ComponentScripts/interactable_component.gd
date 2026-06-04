extends Area2D
class_name InteractableComponent

@onready var label: Label = %Label

@export var enabled : bool = true:
	set = set_enabled
	
@export var auto_interact : bool = false
@export var one_shot : bool = false

var can_interact : bool = false
var interacted : bool = false
var interacted_body : ControllableMob

signal interact
signal exit_interaction

func _ready() -> void:
	label.visible = false

func set_enabled(value : bool):
	enabled = value
	monitoring = value

func _unhandled_input(event: InputEvent) -> void:
	if !enabled:
		return
	
	if event.is_action_pressed("interact") and can_interact and !interacted:
		interact.emit()
		label.visible = !label.visible
		if one_shot:
			interacted = true

func _on_body_entered(body: Node2D) -> void:
	if body is ControllableMob and !interacted:
		can_interact = true
		interacted_body = body
		if auto_interact:
			interacted = true
			interact.emit()
		else:
			label.visible = true

func _on_body_exited(body: Node2D) -> void:
	if body is ControllableMob and !interacted:
		can_interact = false
		interacted_body = null
		label.visible = false
		exit_interaction.emit()
