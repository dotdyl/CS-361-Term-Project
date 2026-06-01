extends State
class_name EnemyState

var enemy : Mob = null:
	get = _get_enemy,
	set = _set_enemy

func _get_enemy() -> Mob:
	return enemy
	
func _set_enemy(value : Mob):
	enemy = value

func _ready():
	# Wait for the top-level parent node (the enemy) to be ready (execute their
	# _ready function), and then assign that node to the enemy variable for
	# reference. Checks to make sure enemy node is actually assigned.
	await owner.ready
	enemy = owner as Mob
	assert(enemy != null)
