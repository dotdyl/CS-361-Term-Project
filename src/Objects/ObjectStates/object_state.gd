extends State
class_name ObjectState

var object : LevelObject = null

func _ready():
	# Wait for the top-level parent node (the player) to be ready (execute their
	# _ready function), and then assign that node to the player variable for
	# reference. Checks to make sure player node is actually assigned.
	await owner.ready
	object = owner as LevelObject
	assert(object != null)
