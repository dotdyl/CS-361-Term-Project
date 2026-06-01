extends EnemyState
class_name EnemyGroundState

func _get_enemy() -> GroundMob:
	return enemy as GroundMob
	
func _set_enemy(value : Mob):
	super(value as GroundMob)

func _ready():
	# Wait for the top-level parent node (the enemy) to be ready (execute their
	# _ready function), and then assign that node to the enemy variable for
	# reference. Checks to make sure enemy node is actually assigned.
	await owner.ready
	enemy = owner as GroundMob
	assert(enemy != null)
