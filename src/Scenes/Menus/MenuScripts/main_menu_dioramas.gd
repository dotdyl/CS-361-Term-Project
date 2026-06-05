extends Node2D

@onready var microservice_manager: MicroserviceManager = %MicroserviceManager

@export var main_menu_dioramas : Array[PackedScene]

var daily_number : int = -1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var response = await microservice_manager.send_request(6000, "/daily_number")
	daily_number = response.body
	var diorama = main_menu_dioramas[(daily_number) % main_menu_dioramas.size()].instantiate()
	add_child(diorama)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
