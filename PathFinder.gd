extends CharacterBody2D
@onready var navigation_agent_2d = $NavigationAgent2D
@export var speed=100
@export var targetpos=Vector2.ZERO
func _physics_process(delta):
	navigation_agent_2d.target_position=targetpos
	var dir = to_local(navigation_agent_2d.get_next_path_position()).normalized()
	velocity=dir*speed
	move_and_slide()
	
func changepath():
	navigation_agent_2d.target_position=targetpos
