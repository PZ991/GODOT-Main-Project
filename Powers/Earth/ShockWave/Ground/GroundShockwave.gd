extends Node3D

var direction=Vector3.ZERO
var end=false
@onready var animation_player = $AnimationPlayer
@onready var ray_cast_2d_2 = $RayCast3D2
@onready var ray_cast_2d = $RayCast3D
@onready var timer = $Timer

func _ready():
	animation_player.queue("maintain")
func _process(delta):


	global_position=Vector3(global_position.x+(direction.x*delta),global_position.y,global_position.z)
	if((not ray_cast_2d.is_colliding())and (direction.x<0 and animation_player.get_current_animation() == "maintain")):
		animation_player.play("End")
	if((not ray_cast_2d_2.is_colliding())and( direction.x>0 and animation_player.get_current_animation() == "maintain")):
		animation_player.play("End")
	if(timer.is_stopped() and end ==false):
		animation_player.play("End")

	

func SetDirection(dir):
	direction=dir

func isAnimationFinished(animation_name: String) -> bool:
	return animation_player.get_current_animation() == animation_name and animation_player.animation_finished 

# Function to check if a specific animation is currently playing
func isAnimationPlaying(animation_name: String) -> bool:
	return animation_player.is_playing() && animation_player.has_animation(animation_name)


func _on_animation_player_animation_finished(anim_name):
	if(anim_name=="End"):
		queue_free()
	pass # Replace with function body.
