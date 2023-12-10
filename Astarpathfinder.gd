extends Node2D

@export var astargridsize= Vector2(32,32)
@export var astarcellsize=Vector2(16,16)


func _ready():
	var astargrid =AStarGrid2D.new()
	
