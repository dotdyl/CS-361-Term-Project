extends CharacterBody2D

@export var controller : MobController
@export var anims : AnimatedSprite2D
@export var moveSpeed : float = 300.0
@export var jumpSpeed : float = -400.0
@export var weight : float = 2.0 # Accelerates gravity

var animVector : Vector2
var moveVector : Vector2
var doJump : bool

func _physics_process(delta: float) -> void:
	
	if controller:
		moveVector = controller.controlVector
		animVector = controller.controlVector
	
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta * weight

	# print(moveVector)

	# Handle jump.
	if moveVector.y > 0 and is_on_floor():
		velocity.y = jumpSpeed

	if moveVector.x:
		velocity.x = moveVector.x * moveSpeed
		anims.play("run")
		
		if moveVector.x < 0:
			anims.flip_h = true
		elif moveVector.x > 0:
			anims.flip_h = false
	else:
		velocity.x = move_toward(velocity.x, 0, moveSpeed)
		anims.play("idle")

	move_and_slide()
