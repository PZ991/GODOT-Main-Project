extends Node3D


var target_pos : Vector3 = Vector3(0, 2,0)  
var startpos=Vector3.ZERO
var speed : float = 100.0  
var tween : Tween = Tween.new()
@onready var rock_summon = $"."



func _process(delta):
	TweenAnimation()

#animate with ease
func TweenAnimation():
	tween = create_tween()
	
	tween.tween_property(rock_summon,"global_position",target_pos+startpos,0.3)

	tween.tween_callback(
	func end_movement():
		rock_summon.global_position = target_pos
)
