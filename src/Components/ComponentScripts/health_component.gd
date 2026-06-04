class_name HealthComponent
extends Area2D

@export var health : int
@export var max_health : int = 5
@export var queue_free_on_death : bool = false
@export var i_frames : float = 0.0

var i_frames_timer : SceneTreeTimer

var parent : Mob

signal damaged
signal adjust_ui
signal on_death

# Called when the node enters the scene tree for the first time.
func _ready():
	health = max_health
	parent = get_parent() as Mob
	on_death.connect(_on_death)
	
func check_health_status():
	
	if health <= 0:
		on_death.emit()
	
func disable():
	monitorable = false

func enable():
	monitorable = true
		
func _on_death():
	if queue_free_on_death:
		parent.queue_free()
	
func gain_health(value : int):
	var curr_health = health
	health = clamp(health + value, 0, max_health)
	adjust_ui.emit(health - curr_health)
	
func simple_damage(damage : int):
	
	if !monitorable:
		return
	
	damaged.emit({"attacker" : null, "direction" : Vector2.UP, "knockback" : 0})
	adjust_ui.emit(-damage)
	health -= damage
	
	start_i_frames()
	
	if health <= 0:
		on_death.emit()
	
func take_damage(attack : Attack, attacker : Node, attack_direction : Vector2):
	
	print("damaged")
	damaged.emit({"attacker" : attacker, "direction" : attack_direction, "knockback" : attack.knockback})
	adjust_ui.emit(-attack.damage)
	health -= attack.damage
	
	start_i_frames()
	
	if health <= 0:
		on_death.emit()

func start_i_frames():
	
	if i_frames <= 0:
		return
	
	i_frames_timer = get_tree().create_timer(i_frames)
	i_frames_timer.timeout.connect(exit_i_frames)
	
	disable()
	
func exit_i_frames():
	
	enable()
