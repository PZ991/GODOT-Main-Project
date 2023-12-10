extends Node2D


var target_pos : Vector2 = Vector2(0, -50)  
var speed : float = 100.0  
var tween : Tween = Tween.new()
@onready var area_2d = $Area2D

func _process(delta):
	TweenAnimation()

#animate with ease
func TweenAnimation():
	tween = create_tween()
	
	tween.tween_property(area_2d,"position",target_pos,0.3)
	tween.tween_callback(
	func end_movement():
		area_2d.position = target_pos
)
