extends Node3D
@onready var animated_sprite_3d = $AnimatedSprite3D


@onready var fall_timer = $"Fall timer"
@onready var F1 = $Sprite3D
@onready var F2 = $Sprite3D2
@onready var F3 = $Sprite3D3
@onready var ray_cast_3d = $RayCast3D


@export var falltime=1

@export var HitVertical:PackedScene
@export var HitHorizontal:PackedScene
@export var speed=100
@export var moving=false
var falling=false
func _ready():
	fall_timer.wait_time=falltime
	fall_timer.start()

	
func _process(delta):
	if ray_cast_3d.is_colliding():
		if not falling:
			var hitinst= HitVertical.instantiate()
			var world = get_tree().current_scene
			world.add_child(hitinst)
			hitinst.global_position=ray_cast_3d.get_collision_point()
			
		queue_free()
	if moving:
		F3.global_position.x+=delta*speed
	pass




func _on_fall_timer_timeout():
	falling=true
	pass # Replace with function body.




func _on_animation_player_animation_finished(anim_name):
	
	pass # Replace with function body.
