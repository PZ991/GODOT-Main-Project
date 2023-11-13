extends CanvasLayer


@onready var animation_player = $AnimationPlayer

signal transitionfinished
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func enter():
	animation_player.play("Enterlevel")
func exit():
	animation_player.play("Exitlevel")


func _on_animation_player_animation_finished(anim_name):
	emit_signal("transitionfinished")
	pass # Replace with function body.
