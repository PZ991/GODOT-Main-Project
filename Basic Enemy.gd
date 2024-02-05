extends CharacterBody3D

@onready var navigation_agent_3d = $NavigationAgent3D
var speed=3.0
var _velocity:Vector3
func _process(delta):
	var currentpos = global_position
	var nextpos=navigation_agent_3d.get_next_path_position()
	var newvelocity=(nextpos-currentpos).normalized()*speed
	_velocity+=newvelocity
	velocity=_velocity
	move_and_slide()
	

func update_target_location(targetpos):
	navigation_agent_3d.target_position=(targetpos)


func _on_navigation_agent_3d_velocity_computed(safe_velocity):
	_velocity=safe_velocity
	pass # Replace with function body.


func _on_navigation_agent_3d_target_reached():
	pass # Replace with function body.
