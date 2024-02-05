extends Node3D

@onready var player_pos = $PlayerPos

func _physics_process(delta):
	get_tree().call_group("Enemy","update_target_location",player_pos.global_position)
