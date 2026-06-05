extends AnimatedSprite2D
class_name MenuSprite

@export var anim_names : Array[String]
@export var idle_buffer_high := 0.5
@export var idle_buffer_low := -1
@export var buddies : Array[MenuSprite] = []
@export var is_buddy : bool = false

var curr_anim : String

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if idle_buffer_low == -1:
		idle_buffer_low = idle_buffer_high
	if !is_buddy:
		pick_ran_anim()
		play_anim(curr_anim)
		animation_finished.connect(go_idle)
	
func pick_ran_anim():
	curr_anim = anim_names.pick_random()
	return curr_anim
	
func play_anim(anim : String):
	play(anim)
	for buddy in buddies:
		buddy.play_anim(anim)

func go_idle():
	if curr_anim == "idle":
		return
	if idle_buffer_high > 0:
		play_anim("idle")
		get_tree().create_timer(randi_range(idle_buffer_low, idle_buffer_high)).timeout.connect(play_anim.bind(pick_ran_anim()))
