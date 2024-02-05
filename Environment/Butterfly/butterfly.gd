extends CharacterBody3D
const SPEED = 100
const TURN_INTERVAL = 2.0  # Seconds between changing directions

var direction = Vector3.RIGHT  # Start moving right
var timer = 0.0

@onready var animated_sprite_3d = $AnimatedSprite3D

func _physics_process(delta):
	direction.y=0
	if velocity.x<0:
		animated_sprite_3d.flip_h=false
	else:
		animated_sprite_3d.flip_h=true
	velocity=direction * SPEED * delta
	move_and_slide()

	timer += delta
	if timer >= TURN_INTERVAL:
		timer = 0.0
		direction = direction.rotated(Vector3.UP,randf() * PI * 2)  # Pick a random new direction
