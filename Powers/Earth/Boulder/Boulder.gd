extends Node3D


var target_pos : Vector3 = Vector3(0, 2,0)  
var startpos=Vector3.ZERO
var speed : float = 100.0  
var tween : Tween 
@onready var rock_summon = $"."
var directionaldestroy=false
var decayed =false
var decaytime =0.0
@onready var timer = $Timer

@export var directionaldestroyed : PackedScene
@export var dissolved : PackedScene
func _ready():
	if decaytime>0:
		timer.wait_time=decaytime

func _process(delta):
	if not directionaldestroy:
		TweenAnimation()
	else:
		if not directionaldestroyed==null:
			var dirdest=directionaldestroyed.instantiate()
			var world = get_tree().current_scene
			world.add_child(dirdest)
			dirdest.scale=scale
			dirdest.global_position=global_position
			queue_free()

#animate with ease
func TweenAnimation():
	tween = create_tween()
	
	tween.tween_property(rock_summon,"global_position",target_pos+startpos,0.3)

	tween.tween_callback(
	func end_movement():
		rock_summon.global_position = target_pos
)

