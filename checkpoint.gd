extends Area2D

@onready var animated_sprite_2d = $AnimatedSprite2D
var active = true

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_body_entered(body):
	if not body is Player:
		return
	if not active: return
	active=false
	animated_sprite_2d.play("checked")
	Events.emit_signal("checkpoint",position)
	pass # Replace with function body.

