@tool
extends Node

class_name TileFinder

@onready var raycast2d = $RayCast3D
@export var NUM_OBJECTS = 20  # Adjust the number of objects in the circle
@export var RADIUS = 50.0  # Adjust the radius of the circle
@onready var collision_shape_2d = $CollisionShape3D
@export var limitedangle=false
@export var angle=90
@export var direction=Vector3.DOWN
@export var clearinbetween=false
@export var origin=Vector3.ZERO

@export var findnearestobject=false
@export var allobject=[]

@export var findnearestgrid=false
@export var Zspeed=5.0
@export var gridsize=Vector3.ONE*0.5
@export var test=false
@onready var sprite_3d = $Sprite3D


func _ready():
	ChangeRadius()
	ProcessRaycasts()

		#icon.global_position=closest_vector

func _process(delta):
	if test:
		ChangeRadius()
		sprite_3d.global_position=ProcessRaycasts()
		test=false

func ChangeRadius():
	collision_shape_2d.shape.radius=RADIUS

func ProcessRaycasts()-> Vector3:
	var hits=[]
	var closest_vector=null

	if not findnearestobject and not findnearestgrid:
		for i in range(NUM_OBJECTS):
			var theta = i * (2 * PI / NUM_OBJECTS)
			var phi = PI * (i + 0.5) / float(NUM_OBJECTS)
			var x = RADIUS * sin(phi) * cos(theta)
			var y = RADIUS * sin(phi) * sin(theta)
			var z = RADIUS * cos(phi)
		
			raycast2d.target_position=Vector3(x, y,z)
			raycast2d.force_raycast_update()
			if(raycast2d.is_colliding()):
				
				hits.append(raycast2d.get_collision_point())
				
			
			#if hits.size()>0:
			#	print("true")

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
			hits=newhits
	
	elif findnearestobject and not findnearestgrid:
		for i in allobject:
			hits.append(allobject.global_position)
		
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
			hits=newhits
	
	elif findnearestgrid and not findnearestobject:
		if Input.is_action_pressed("ui_text_scroll_up"):
			print("scroll")
		hits.append(round_to_grid(raycast2d.global_position))
	closest_vector = find_closest_point(hits)
	
	if(clearinbetween):
		raycast2d.global_position=origin
		raycast2d.target_position=closest_vector
		raycast2d.force_raycast_update()
		if(raycast2d.is_colliding()):
			closest_vector=Vector3.ZERO
		raycast2d.global_position=Vector3.ZERO
	
	
	return closest_vector
	

func find_closest_point(points_array) -> Vector3:
	var closest_point : Vector3
	var closest_distance : float=999999

	for point in points_array:
		var distance : float = point.distance_squared_to($RayCast3D.global_position)
		if distance < closest_distance:
			closest_distance = distance
			closest_point = point

	return closest_point

func round_to_grid(input_vector: Vector3) -> Vector3:
	var rounded_vector = Vector3()
	rounded_vector.x = round(input_vector.x / gridsize.x) * gridsize.x
	rounded_vector.y = round(input_vector.y / gridsize.y) * gridsize.y
	rounded_vector.z = round(input_vector.z / gridsize.z) * gridsize.z
	return rounded_vector

func _on_body_entered(body):
	if findnearestobject:
		allobject.append(body)


func _on_body_exited(body):
	if findnearestobject:
		if allobject.has(body):
			allobject.erase(body)

func _input(event):
	if findnearestgrid:
		if event is InputEventMouseButton:
			if event.button_index == MOUSE_BUTTON_WHEEL_UP and event.pressed:
				raycast2d.global_position.z+=Zspeed
