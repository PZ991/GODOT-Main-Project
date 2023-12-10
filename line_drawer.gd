extends Node2D
@onready var ray_cast_2d = $Linecaster
@onready var Linechecker = $Linechecker
@onready var static_body_2d = $StaticBody2D
@onready var line_2d = $Line2D

var lastfreepoint=Vector2.ZERO
var linetarget= Vector2.ONE
var linestart = Vector2.ZERO
var linesegments=[]

func _ready():
	InitializeLine()

func _physics_process(delta):
	
	CheckLineCollision()
	
	UpdateRenderer()
	
	DisplayLine()

#initialize base of line
func InitializeLine():
	linesegments.append(linestart)
	linesegments.append(linetarget)

#check line for collisions for any updates
func CheckLineCollision():
	ray_cast_2d.global_position=linestart
	ray_cast_2d.target_position=linetarget
	ray_cast_2d.force_raycast_update()
	if not ray_cast_2d.is_colliding():
		lastfreepoint=linetarget
	else:
		var collider =ray_cast_2d.get_collider()
		var vertices = collider.get_polygon()
		for i in vertices:
			if is_point_inside_triangle(i,lastfreepoint,linestart,linetarget):
				linesegments.insert(linesegments.size()-1,i)
				linetarget=linesegments[1]

#update the line and check if it needs to reduce
func UpdateRenderer():
	if linesegments.size()>2:
		Linechecker.global_position=linesegments[2]
		Linechecker.target_position=linesegments[0]
		Linechecker.force_raycast_update()
		if(not Linechecker.is_colliding()):
			linesegments.remove_at(1)
			linetarget=linesegments[1]

#Show line
func DisplayLine():
	for points in linesegments:
		line_2d.points=linesegments

func is_point_inside_triangle(point: Vector2, v1: Vector2, v2: Vector2, v3: Vector2) -> bool:
	# Calculate barycentric coordinates
	var denominator = (v2.y - v3.y) * (v1.x - v3.x) + (v3.x - v2.x) * (v1.y - v3.y)
	var a = ((v2.y - v3.y) * (point.x - v3.x) + (v3.x - v2.x) * (point.y - v3.y)) / denominator
	var b = ((v3.y - v1.y) * (point.x - v3.x) + (v1.x - v3.x) * (point.y - v3.y)) / denominator
	var c = 1.0 - a - b

	# Check if point is inside the triangle

	return ((0.0 <= a)and (a <= 1.0)) and ((0.0 <= b)and (b  <= 1.0)) and ((0.0 <= c )and (c<= 1.0))
