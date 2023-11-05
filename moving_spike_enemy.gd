
extends Path2D

enum AnimationType { Loop, Bounce }

@export var anim_type: AnimationType = AnimationType.Loop

	

@onready var animation_player = $AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready():
	play_updated_anim()

func set_anim_type(value):
	anim_type = value
	play_updated_anim()

func play_updated_anim():
	if animation_player==null:
		animation_player=$AnimationPlayer
	
	match anim_type:
		AnimationType.Loop:
			animation_player.play("MoveAlongPath")
		AnimationType.Bounce:
			animation_player.play("MoveAlongPath_Open")
