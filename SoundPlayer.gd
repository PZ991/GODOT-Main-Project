extends Node

@onready var audioplayers= $AudioPlayers
const Hurt =preload("res://Sounds/hurt.wav")
const Jump =preload("res://Sounds/jump.wav")


# Called when the node enters the scene tree for the first time.
func _ready():

	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	pass
	
func playsound(sound):
	for audioStreamPlayer in audioplayers.get_children():
		if not audioStreamPlayer.playing:
			audioStreamPlayer.stream=sound
			audioStreamPlayer.play()
			break

