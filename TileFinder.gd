extends Node

class_name TileFinder

@onready var raycast2d = $RayCast2D
@export var NUM_OBJECTS = 20  # Adjust the number of objects in the circle
@export var RADIUS = 50.0  # Adjust the radius of the circle
@onready var collision_shape_2d = $CollisionShape2D
@export var limitedangle=false
@export var angle=90
@export var direction=Vector2.DOWN
@export var clearinbetween=false
@export var origin=Vector2.ZERO
func _ready():
	ChangeRadius()
	ProcessRaycasts()

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
		
		#if hits.size()>0:
			#print("true")

		#else:
			#print("false")
			
	if limitedangle:
		var newhits = []
		for hit in hits:
			var hit_location = hit
			var to_hit_vector = hit_location-raycast2d.global_position
			var angle_to_hit = rad_to_deg( to_hit_vector.angle_to(direction))
			#print(angle_to_hit)

		# Check if the hit is within the field of view angle
			if (angle_to_hit <= angle) and (angle_to_hit >= -angle):
			# The object is within the field of view
				#print("Object in sight!")
				newhits.append(hit)
			#else:
			# The object is outside the field of view
				
					#print("Off Object in sight!")
	closest_vector = find_closest_point(hits)
	
	if(clearinbetween):
		raycast2d.global_position=origin
		raycast2d.target_position=closest_vector
		raycast2d.force_raycast_update()
		if(raycast2d.is_colliding()):
			closest_vector=Vector2.ZERO
		raycast2d.global_position=Vector2.ZERO
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

