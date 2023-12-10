extends Node2D

class_name InstanceWall
@export var data: InstanceData

@export var iswall:bool
@export var friendlyfire:bool
@export var hp:float
@export var timerstart:float=-1
@export var timerdestroy:float=-1
var destroying=false
@export var usedestroyanim=false
@export var reverseretract=false
@export var directiondestroy=Vector3.ZERO


func _physics_process(delta):
	if not timerstart and not destroying==-1:
		$Timer.start(timerstart)
	else:
		$AnimationPlayer.play("Up")
		
	if($AnimationPlayer.animation_finished and $Timer.timeout and not destroying):
		if timerdestroy >-1:
			$Timer.start(timerdestroy)
			destroying=true
		
		
	if(destroying and $Timer.timeout ):
		destroy()
	
	if($AnimationPlayer.animation_finished and $AnimationPlayer.is_playing()):
		if(hp<=0):
			destroy()
		
func destroy():
	if reverseretract:
		$AnimationPlayer.play_backwards("Up")
	else:
		queue_free()
		
