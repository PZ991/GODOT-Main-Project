extends Area2D

@onready var animated_sprite_2d = $AnimatedSprite2D
var active = true

#when player enters collision box
func _on_body_entered(body):
	if not body is Player:
		return
	if not active: return
	active=false
	animated_sprite_2d.play("checked")
	Events.emit_signal("checkpoint",position)


