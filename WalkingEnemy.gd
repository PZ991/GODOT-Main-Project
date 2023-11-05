extends CharacterBody2D

class_name WalkingEnemy
var direction = Vector2.RIGHT
const SPEED = 100.0


# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

@onready var ledgecheck = $LedgeCheckR
@onready var ledgecheck2 = $LedgeCheckL
@onready var animatedsprite= $AnimatedSprite2D
func _physics_process(delta):
	# Add the gravity.
	var found_wall = is_on_wall()
	var found_ledge = not ledgecheck.is_colliding() or not ledgecheck2.is_colliding()
	if not is_on_floor() :
		velocity.y += gravity * delta

	# Handle Jump.
	if found_wall or found_ledge:
		direction*=-1
	velocity=direction*SPEED
	
	animatedsprite.flip_h= direction.x>0

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	

	move_and_slide()
