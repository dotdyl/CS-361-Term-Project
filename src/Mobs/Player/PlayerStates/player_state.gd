extends State
class_name PlayerState

var player : Mob = null

func _ready():
	# Wait for the top-level parent node (the player) to be ready (execute their
	# _ready function), and then assign that node to the player variable for
	# reference. Checks to make sure player node is actually assigned.
	await owner.ready
	player = owner as Mob
	assert(player != null)

func handle_input(_event: InputEvent) -> void:
	pass
