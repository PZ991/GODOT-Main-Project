extends Node2D

enum {Rising, Hover,Fall,Land}
var state=Hover

@onready var startposition=global_position
@onready var timer = $Timer
@onready var ray_cast_2d = $RayCast2D
@onready var animated_sprite_2d = $AnimatedSprite2D
@onready var gpu_particles_2d = $GPUParticles2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	match state:
		Hover:hoverstate()
		Land:land()
		Rising:rise(delta)
		Fall:fall(delta)
	pass

func hoverstate():
	state=Fall
#	if timer.time_left==0: timer.start()

func fall(delta):
	animated_sprite_2d.play("Falling")
	position.y+=100*delta
	if ray_cast_2d.is_colliding():
		var col=ray_cast_2d.get_collision_point()
		position.y=col.y
		state=Land
		timer.start(0.5)
		gpu_particles_2d.emitting=true;

func land():

	if timer.time_left==0:
		state=Rising
	
func rise(delta):

	animated_sprite_2d.play("Rising")
	position.y=move_toward(position.y,startposition.y,10*delta)
	if position.y == startposition.y:
		state=Hover
	pass
