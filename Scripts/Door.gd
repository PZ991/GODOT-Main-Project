extends Area2D

@export_file("*tscn") var level

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_body_entered(body):
	if not body is Player: return
	if level.is_empty(): return
	Transition.exit()
	get_tree().paused=true
	await Transition.transitionfinished
	get_tree().change_scene_to_file(level)
	get_tree().paused=false
	Transition.enter()
	pass # Replace with function body.
