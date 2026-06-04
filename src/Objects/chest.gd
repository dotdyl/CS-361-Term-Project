extends LevelObject

@onready var health_component: HealthComponent = %HealthComponent

@export var potential_contents : Array[PackedScene]
@export var garunteed_contents_count := 1.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	sprite.play("closed")
	health_component.on_death.connect(open)

func open():
	sprite.play("open")
	while garunteed_contents_count > 0:
		print(potential_contents)
		var loot = potential_contents.pick_random().instantiate() as Item
		get_tree().current_scene.call_deferred("add_child", loot)
		loot.global_position = global_position
		await loot.ready
		loot.spawn()
		garunteed_contents_count -= 1
