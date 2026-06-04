extends Node2D
class_name ManaComponent

@export var mana : int
@export var max_mana := 3

signal adjust_ui

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	mana = 0

func gain_mana(value : int):
	var curr_mana = mana
	mana = clamp(mana + value, 0, max_mana)
	adjust_ui.emit(mana - curr_mana)

func consume_mana(value : int):
	mana -= value
	adjust_ui.emit(-value)
