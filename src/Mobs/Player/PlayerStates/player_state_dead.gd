extends PlayerState

func enter(_msg := {}):
	player.velocity = Vector2.ZERO
	player.can_input = false
	player.sprite.play("dead")
	
