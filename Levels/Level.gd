extends Node2D

@onready var camera_2d = $Camera2D
@onready var player = $Player
const playerscene = preload("res://player.tscn")
@onready var timer = $Timer

var spanwlocation = Vector2.ZERO
# Called when the node enters the scene tree for the first time.
func _ready():
	RenderingServer.set_default_clear_color(Color.CADET_BLUE)
	player.connectcam(camera_2d)
	Events.playerdied.connect(onplayerdead)
	Events.checkpoint.connect(setposition)
	spanwlocation= player.global_position
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
func onplayerdead():
	timer.start(1)
	await timer.timeout 
	var player = playerscene.instantiate()
	add_child(player)
	player.global_position=spanwlocation
	player.connectcam(camera_2d)
	pass

func setposition(newposition):
	spanwlocation=newposition
