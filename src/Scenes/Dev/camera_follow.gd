extends Camera2D

@export var target : Node
@export var threshold : float = 100

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	var yDist = abs(global_position.y - target.global_position.y)
	#print(yDist)
	
	if yDist > threshold:
		var targetY = global_position.y - threshold
		var tween = create_tween()
		tween.tween_property(self, "global_position:y", target.global_position.y - 50, 0.4)
