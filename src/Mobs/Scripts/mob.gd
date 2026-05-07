class_name Mob
extends CharacterBody2D

@export var controller : MobController
@export var anim : AnimatedSprite2D
@export var attack : AttackComponent
@export var health : HealthComponent
@export var moveSpeed : float = 300.0
@export var jumpSpeed : float = -400.0
@export var weight : float = 2.0 # Accelerates gravity

var animVector : Vector2
var moveVector : Vector2
var faceDir : float = 0
var doDash : float
var doAtk : float
var onFloor : bool = true

func _physics_process(delta: float) -> void:
	
	if not is_on_floor():
		coyoteTime()
	else:
		onFloor = true
	
	if controller:
		moveVector = controller.controlVector
		animVector = controller.controlVector
		doDash = controller.dash
		doAtk = controller.atk
	
	# Add the gravity.
	if not is_on_floor() and not doDash:
		velocity += get_gravity() * delta * weight

	# Handle jump.
	if moveVector.y > 0 and onFloor:
		velocity.y = jumpSpeed
		onFloor = false

	if doAtk > 0:
		attack.monitoring = true
		anim.play("attack")
	else:
		attack.monitoring = false

	if doDash > 0:
		velocity.x = 25000 * delta * faceDir
		velocity.y = 0
	elif moveVector.x and doAtk <= 0:
		velocity.x = moveVector.x * moveSpeed * 50 * delta
		
		anim.play("run")
		if moveVector.x < 0:
			anim.flip_h = true
			faceDir = -1.0
			if attack.position.x > 0:
				attack.position.x *= -1
		elif moveVector.x > 0:
			anim.flip_h = false
			faceDir = 1.0
			if attack.position.x < 0:
				attack.position.x *= -1
	else:
		velocity.x = move_toward(velocity.x, 0, moveSpeed)
		if doAtk <= 0:
			anim.play("idle")

	move_and_slide()
	
func coyoteTime() -> void:
	
	await get_tree().create_timer(0.2).timeout
	if is_on_floor() == false:
		onFloor = false
