extends CanvasLayer
class_name UIManager

@onready var sign_panel: Panel = %SignPanel
@onready var sign_label: Label = %SignLabel
@onready var hearts_container: HBoxContainer = %HeartsContainer
@onready var mana_container: HBoxContainer = %ManaContainer
@onready var game_over_panel: Panel = %GameOverPanel
@onready var write_note_panel: Panel = %WriteNotePanel
@onready var message_text_edit: TextEdit = %MessageTextEdit
@onready var author_line_edit: LineEdit = %AuthorLineEdit

@export var health_component : HealthComponent
@export var mana_component : ManaComponent

var player : Mob

const HEART_SYMBOL = preload("res://UI/heart_symbol.tscn")
const MANA_SYMBOL = preload("res://UI/mana_symbol.tscn")

signal write_note

func _ready():
	load_hearts(health_component.max_health)
	load_mana(mana_component.max_mana)
	adjust_mana(-mana_component.max_mana)
	health_component.adjust_ui.connect(adjust_hearts)
	mana_component.adjust_ui.connect(adjust_mana)
	
	player = get_parent()

func toggle_note_writing(do : bool):
	write_note_panel.visible = do

func toggle_game_over(do : bool):
	game_over_panel.visible = do

func toggle_sign(do : bool, text : String):
	sign_panel.visible = do
	if do:
		print(text)
		display_sign_message(text)

func load_mana(num : int):
	for i in num:
		var symbol = MANA_SYMBOL.instantiate()
		mana_container.add_child(symbol)

func adjust_mana(value : int):
	var i = 1
	var index
	if value < 0: index = 0
	else: index = -1
	while i <= abs(value):
		var symbol = mana_container.get_child(index)
		if !symbol:
			break
		var sprite = symbol.get_child(0) as AnimatedSprite2D
		if !sprite:
			break
		if value < 0: 
			if sprite.animation != "broken":
				sprite.play("broken")
				i += 1
		else: 
			if sprite.animation != "full": 
				sprite.play("full")
				i += 1
		if value < 0: index += 1
		else: index -= 1

func load_hearts(num : int):
	for i in num:
		var symbol = HEART_SYMBOL.instantiate()
		hearts_container.add_child(symbol)
		
func adjust_hearts(value : int):
	var i = 1
	var index
	if value < 0: index = -1
	else: index = 0
	while i <= abs(value):
		var symbol = hearts_container.get_child(index)
		if !symbol:
			break
		var sprite = symbol.get_child(0) as AnimatedSprite2D
		if !sprite:
			break
		if value < 0: 
			if sprite.animation != "broken":
				sprite.play("broken")
				i += 1
		else: 
			if sprite.animation != "full": 
				sprite.play("full")
				i += 1
		if value < 0: index -= 1
		else: index += 1

func display_sign_message(text : String):
	sign_label.text = text

func _on_exit_button_pressed() -> void:
	Loading.load_scene("Menus/main_menu.tscn")

func _on_respawn_button_pressed() -> void:
	get_tree().reload_current_scene()

func _on_note_send_button_pressed() -> void:
	var additional_data = {
			"x": player.global_position.x,
			"y" : player.global_position.y
	}
	write_note.emit(message_text_edit.text, author_line_edit.text, additional_data)
	toggle_note_writing(false)
