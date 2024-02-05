extends Node3D

var move =false
var direction=Vector3.ZERO
@onready var animated_sprite_3d = $AnimatedSprite3D

func _process(delta):
	if move:
		direction.y=0
		translate(((direction*.05))+(.25*Vector3.UP))
		if direction.x>0:
			animated_sprite_3d.flip_v=false
			animated_sprite_3d.global_rotation_degrees.z=45
		else :
			animated_sprite_3d.flip_v=true
			animated_sprite_3d.sglobal_rotation_degrees.z=45
		

func _on_area_3d_body_entered(body):
	
	if body is CharacterBody3D and (body.name=="Player3D2"or body.name=="PlayerV3"):
		direction=global_position-body.position
		print(direction)
		move=true
		
	pass # Replace with function body.
