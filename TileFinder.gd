extends Node

@onready var raycast2d = $RayCast2D
@export var NUM_OBJECTS = 20  # Adjust the number of objects in the circle
@export var RADIUS = 50.0  # Adjust the radius of the circle
@onready var collision_shape_2d = $CollisionShape2D

func _ready():
	ChangeRadius()

		#icon.global_position=closest_vector

func ChangeRadius():
	collision_shape_2d.global_scale=Vector2(RADIUS/10,RADIUS/10)

func ProcessRaycasts()-> Vector2:
	var hits=[]
	var closest_vector=null

		
	for i in range(NUM_OBJECTS):
		var angle = i * (2 * PI / NUM_OBJECTS)
		var x = cos(angle) * RADIUS
		var y = sin(angle) * RADIUS
	
		raycast2d.target_position=Vector2(x, y)
		raycast2d.force_raycast_update()
		if(raycast2d.is_colliding()):
			hits.append(raycast2d.get_collision_point())
		
		if hits.size()>0:
			print("true")

		else:
			print("false")
	closest_vector = find_closest_point(hits)
	return closest_vector
	

func find_closest_point(points_array) -> Vector2:
	var closest_point : Vector2
	var closest_distance : float=999999

	for point in points_array:
		var distance : float = point.distance_squared_to($RayCast2D.global_position)
		if distance < closest_distance:
			closest_distance = distance
			closest_point = point

	return closest_point
	pass # Replace with function body.
