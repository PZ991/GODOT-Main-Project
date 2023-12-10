@tool
extends Node3D
@onready var node_3d = $"."
@export_category("Noise Generation")
@export var texture:ImageTexture
@export var proc=false

@export var blur=false
@export var col=0.0
@export var color: Color
@export var arraynum=[]
@export var normalize=false

@export_category("Analyzer Terrain Data")
@export var currentdata: Terrainshapedata



@export var imageprcessing=[]
@export_category("Analyzer Terrain Option")
@export var heightthreshold=0.1
@export var analyzedgrid=[[]]
@export var size3X3=Vector3.ONE*3

@export var uselimitY=false
@export var limitY=1
@export var Ymultiplier=1.0
@export var Xmultiplier=1.0
func _process(delta):
	color=Color(col,col,col,1)

	if proc== true:
		var img=generate_noise_texture()
		if(blur):
			texture = blur_image(img,1)
		else:
			texture=img
		processvalue()
		proc=false
	if normalize:
		
		#print(normalizeArray(arraynum))
		normalize=false
		
func generate_noise_texture():
  # Initialize FastNoiseLite
	var noise = FastNoiseLite.new()
  
  # Define noise parameters
	noise.noise_type = FastNoiseLite.TYPE_PERLIN
	noise.frequency = 50
	noise.fractal_gain=0
	noise.offset=Vector3(0.1,0,0)
  # Create image
	var image = Image.new()
	image=Image.create(100, 4, false, Image.FORMAT_L8)
	  # Generate noise
	for y in range(4):
		for x in range(100):

			var value = noise.get_noise_2d(x / 100.0, y / 4.0)
			image.set_pixel(x, y, Color(value,value,value))
			#print(( Color(value,value,value)))
#			print("x: " + str(x) + " y: " + str(y) + " val: " + str(value * 255.0 + 127.5))

	var image_texture = ImageTexture.new()
	image_texture=ImageTexture.create_from_image(image)
  
	return image_texture

func blur_image(image_texture: ImageTexture, blur_value: int):
	var image = image_texture.get_image()
	var width = image.get_width() 
	var height = image.get_height()

	# Create a temporary image for storing the blurred result
	var blurred_image = Image.new()
	blurred_image=Image.create(width, height, false, Image.FORMAT_RGBA8)	

	# Iterate through each pixel in the original image
	for x in range(width):
		for y in range(height):
			var total_color = Color(0, 0, 0, 0)

			# Iterate through a neighborhood around the current pixel
			for dx in range(-blur_value, blur_value + 1):
				for dy in range(-blur_value, blur_value + 1):
					var nx = x + dx
					var ny = y + dy

					# Make sure the coordinates are within bounds
					nx = clamp(nx, 0, width - 1)
					ny = clamp(ny, 0, height - 1)
					
					var pixel_color = image.get_pixel(nx, ny)
					total_color += pixel_color

			# Average the color values to achieve the blur effect
			var average_color = total_color / ((2 * blur_value + 1) * (2 * blur_value + 1))
			blurred_image.set_pixel(x, y, average_color)


	# Apply the changes to the blurred image
	image_texture = ImageTexture.new()
	image_texture=ImageTexture.create_from_image(blurred_image)


	return image_texture


func colorToFloat(color: Color) -> float:
	# Ensure the color is in grayscale (black and white)
	var grayscaleColor = color.g

	# Map the grayscale color to a float between 0 and 1
	var normalizedValue = grayscaleColor / 255.0

	# Ensure the result is within the valid range [0, 1]
	return clamp(normalizedValue, 0.0, 1.0)

func normalizeArray(floatarray:Array)->Array:
	var sum =0
	for num in floatarray:
		sum+=num
	var newarray=[]
	for num in floatarray:
		newarray.append(inverse_lerp (0.0,sum,num))
	return newarray

func processvalue():
	analyzedgrid= [[]]
	if(texture!=null):
		for X in texture.get_width():
			analyzedgrid.append([])
			for Z in texture.get_height():
				var pixel = texture.get_image().get_pixel(X,Z)
				var newY =999
				if uselimitY:
					newY=limitY
				var cuts =clamp(floor(abs( pixel.g)/heightthreshold),1,newY)
				#print(pixel.g)
				
				#var world = get_tree().current_scene
				#world.add_child(instance)
				var Yval =0
				if(currentdata.only3Y):
					Yval=1
				if(currentdata.only2Y):
					Yval=0.667
				if(currentdata.only1Y):
					Yval=0.333
				
				if(cuts==1):
					if(currentdata.useslope):
						var onleft=false
						var onright=false
						var onfront=false
						var onback=false
						var frontleft=false
						var frontright=false
						var backleft=false
						var backright=false
						
						for dx in range(-1, 2):
							for dz in range(-1, 2):
								
								var nx = X + dx
								var nz = Z + dz
								nx = clamp(nx, 0, texture.get_width() - 1)
								nz = clamp(nz, 0, texture.get_height() - 1)
								var pixel2 = texture.get_image().get_pixel(nx,nz)
								var cuts2 =clamp(floor(abs( pixel2.g)/heightthreshold),1,newY)
								
								if cuts2-cuts>=1:
									#region DXZ boolean
									if dx == -1 and dz == -1:
										backleft=true
										
									if dx==-1 and dz==0:
										onleft=true
										
									if dx==-1 and dz==1:
										frontleft=true
										
									
									if dx==0 and dz==-1:
										onback=true
										
									if dx==0 and dz==1:
										onfront=true
										
										
									if dx==1 and dz==-1:
											backright=true
											
									if dx==1 and dz==0:
										onright=true
											
									if dx==1 and dz==1:
										frontright=true
											
										#endregion
						
						if onright and not onleft and not onback and not onfront:
							var instanceslope =currentdata.Slope_mesh.instantiate()
							add_child(instanceslope)
							instanceslope.global_position=global_position+(Vector3(size3X3.x*X*Xmultiplier,size3X3.y*Yval*Ymultiplier,size3X3.z*Z))
							instanceslope.global_scale(Vector3(1,Yval*Ymultiplier,1*Xmultiplier))
							instanceslope.rotate_y(deg_to_rad(90))
							
						elif onleft and not onright and not onback and not onfront:
							var instanceslope =currentdata.Slope_mesh.instantiate()
							add_child(instanceslope)
							instanceslope.global_position=global_position+(Vector3(size3X3.x*X*Xmultiplier,size3X3.y*Yval*Ymultiplier,size3X3.z*Z))
							instanceslope.global_scale(Vector3(1,Yval*Ymultiplier,1*Xmultiplier))
							instanceslope.rotate_y(deg_to_rad(-90))
							
							
						elif onback and not onfront and not onright and not onleft:
							var instanceslope =currentdata.Slope_mesh.instantiate()
							add_child(instanceslope)
							instanceslope.global_position=global_position+(Vector3(size3X3.x*X*Xmultiplier,size3X3.y*Yval*Ymultiplier,size3X3.z*Z))
							instanceslope.global_scale(Vector3(1*Xmultiplier,Yval*Ymultiplier,1))
							instanceslope.rotate_y(deg_to_rad(180))
							
						elif onfront and not onback and not onright and not onleft:
							var instanceslope =currentdata.Slope_mesh.instantiate()
							add_child(instanceslope)
							instanceslope.global_position=global_position+(Vector3(size3X3.x*X*Xmultiplier,size3X3.y*Yval*Ymultiplier,size3X3.z*Z))
							instanceslope.global_scale(Vector3(1*Xmultiplier,Yval*Ymultiplier,1))
							
						elif onfront and onleft and not onback and not onright:
							var instanceslope =currentdata.slope2_mesh.instantiate()
							add_child(instanceslope)
							instanceslope.global_position=global_position+(Vector3(size3X3.x*X*Xmultiplier,size3X3.y*Yval*Ymultiplier,size3X3.z*Z))
							instanceslope.global_scale(Vector3(1,Yval*Ymultiplier,1*Xmultiplier))
							instanceslope.rotate_y(deg_to_rad(-90))
							
						elif onfront and onright  and not onback and not onleft:
							var instanceslope =currentdata.slope2_mesh.instantiate()
							add_child(instanceslope)
							instanceslope.global_position=global_position+(Vector3(size3X3.x*X*Xmultiplier,size3X3.y*Yval*Ymultiplier,size3X3.z*Z))
							instanceslope.global_scale(Vector3(1*Xmultiplier,Yval*Ymultiplier,1))
							
						elif onback and onright  and not onfront and not onleft:
							var instanceslope =currentdata.slope2_mesh.instantiate()
							add_child(instanceslope)
							instanceslope.global_position=global_position+(Vector3(size3X3.x*X*Xmultiplier,size3X3.y*Yval*Ymultiplier,size3X3.z*Z))
							instanceslope.global_scale(Vector3(1,Yval*Ymultiplier,1*Xmultiplier))
							instanceslope.rotate_y(deg_to_rad(90))
							
						elif onback and onleft  and not onfront and not onright:
							var instanceslope =currentdata.slope2_mesh.instantiate()
							add_child(instanceslope)
							instanceslope.global_position=global_position+(Vector3(size3X3.x*X*Xmultiplier,size3X3.y*Yval*Ymultiplier,size3X3.z*Z))
							instanceslope.global_scale(Vector3(1*Xmultiplier,Yval*Ymultiplier,1))
							instanceslope.rotate_y(deg_to_rad(180))
							

						elif not onback and not onleft and not onfront and not onright:
							if frontright and not frontleft and not backleft and not backright:
								
								var instanceslope =currentdata.Slopecorner_mesh.instantiate()
								add_child(instanceslope)
								instanceslope.global_position=global_position+(Vector3(size3X3.x*X*Xmultiplier,size3X3.y*Yval*Ymultiplier,size3X3.z*Z))
								instanceslope.global_scale(Vector3(1*Xmultiplier,Yval*Ymultiplier,1))
								
								#instanceslope.rotate_y(deg_to_rad(180))
							if frontleft and not frontright and not backleft and not backright:
								var instanceslope =currentdata.Slopecorner_mesh.instantiate()
								add_child(instanceslope)
								instanceslope.global_position=global_position+(Vector3(size3X3.x*X*Xmultiplier,size3X3.y*Yval*Ymultiplier,size3X3.z*Z))
								instanceslope.global_scale(Vector3(1,Yval*Ymultiplier,1*Xmultiplier))
								instanceslope.rotate_y(deg_to_rad(-90))
								
							if backleft and not frontleft and not frontright and not backright:
								var instanceslope =currentdata.Slopecorner_mesh.instantiate()
								add_child(instanceslope)
								instanceslope.global_position=global_position+(Vector3(size3X3.x*X*Xmultiplier,size3X3.y*Yval*Ymultiplier,size3X3.z*Z))
								instanceslope.global_scale(Vector3(1*Xmultiplier,Yval*Ymultiplier,1))
								instanceslope.rotate_y(deg_to_rad(180))
								
							if backright and not frontright and not backleft and not frontleft:
								var instanceslope =currentdata.Slopecorner_mesh.instantiate()
								add_child(instanceslope)
								instanceslope.global_position=global_position+(Vector3(size3X3.x*X*Xmultiplier,size3X3.y*Yval*Ymultiplier,size3X3.z*Z))
								instanceslope.global_scale(Vector3(1,Yval*Ymultiplier,1*Xmultiplier))
								instanceslope.rotate_y(deg_to_rad(90))
								
							if backleft and frontright and not backright and not frontleft:
								var instanceslope =currentdata.slopediagonal.instantiate()
								add_child(instanceslope)
								instanceslope.global_position=global_position+(Vector3(size3X3.x*X*Xmultiplier,size3X3.y*Yval*Ymultiplier,size3X3.z*Z))
								instanceslope.global_scale(Vector3(1*Xmultiplier,Yval*Ymultiplier,1))
								
							if backright and frontleft and not backleft and not frontright:
								var instanceslope =currentdata.slopediagonal.instantiate()
								add_child(instanceslope)
								instanceslope.global_position=global_position+(Vector3(size3X3.x*X*Xmultiplier,size3X3.y*Yval*Ymultiplier,size3X3.z*Z))
								instanceslope.global_scale(Vector3(1,Yval*Ymultiplier,1*Xmultiplier))
								instanceslope.rotate_y(deg_to_rad(90))
								
							
					var instance =currentdata.top_mesh.instantiate()
					add_child(instance)
					instance.global_position=global_position+(Vector3(size3X3.x*X*Xmultiplier,0,size3X3.z*Z))
					
					instance.global_scale(Vector3(1*Xmultiplier,Yval*Ymultiplier,1))
				else:
					
					for Y in cuts:
						if (Y==(cuts-1)):
							var onleft=false
							var onright=false
							var onfront=false
							var onback=false
							var frontleft=false
							var frontright=false
							var backleft=false
							var backright=false
							
							for dx in range(-1, 2):
								for dz in range(-1, 2):
									
									var nx = X + dx
									var nz = Z + dz
									nx = clamp(nx, 0, texture.get_width() - 1)
									nz = clamp(nz, 0, texture.get_height() - 1)
									var pixel2 = texture.get_image().get_pixel(nx,nz)
									var cuts2 =clamp(floor(abs( pixel2.g)/heightthreshold),1,newY)
									
									if cuts2-cuts>=1:
										#region DXZ boolean
										if dx == -1 and dz == -1:
											backleft=true
											
										if dx==-1 and dz==0:
											onleft=true
											
										if dx==-1 and dz==1:
											frontleft=true
											
										
										if dx==0 and dz==-1:
											onback=true
											
										if dx==0 and dz==1:
											onfront=true
											
											
										if dx==1 and dz==-1:
												backright=true
												
										if dx==1 and dz==0:
											onright=true
												
										if dx==1 and dz==1:
											frontright=true
												
											#endregion
										
							if onright and not onleft and not onback and not onfront:
								var instanceslope =currentdata.Slope_mesh.instantiate()
								add_child(instanceslope)
								instanceslope.global_position=global_position+(Vector3(size3X3.x*X*Xmultiplier,(size3X3.y*(Y+1))*Yval*Ymultiplier,size3X3.z*Z))
								instanceslope.global_scale(Vector3(1,Yval*Ymultiplier,1*Xmultiplier))
								instanceslope.rotate_y(deg_to_rad(90))
							elif onleft and not onright and not onback and not onfront:
								var instanceslope =currentdata.Slope_mesh.instantiate()
								add_child(instanceslope)
								instanceslope.global_position=global_position+(Vector3(size3X3.x*X*Xmultiplier,(size3X3.y*(Y+1))*Yval*Ymultiplier,size3X3.z*Z))
								instanceslope.global_scale(Vector3(1,Yval*Ymultiplier,1*Xmultiplier))
								instanceslope.rotate_y(deg_to_rad(-90))
								
							elif onback and not onfront and not onright and not onleft:
								var instanceslope =currentdata.Slope_mesh.instantiate()
								add_child(instanceslope)
								instanceslope.global_position=global_position+(Vector3(size3X3.x*X*Xmultiplier,(size3X3.y*(Y+1))*Yval*Ymultiplier,size3X3.z*Z))
								instanceslope.global_scale(Vector3(1*Xmultiplier,Yval*Ymultiplier,1))
								instanceslope.rotate_y(deg_to_rad(180))
							elif onfront and not onback and not onright and not onleft:
								var instanceslope =currentdata.Slope_mesh.instantiate()
								add_child(instanceslope)
								print("front")
								instanceslope.global_position=global_position+(Vector3(size3X3.x*X*Xmultiplier,(size3X3.y*(Y+1))*Yval*Ymultiplier,size3X3.z*Z))
								instanceslope.global_scale(Vector3(1*Xmultiplier,Yval*Ymultiplier,1))
							elif onfront and onleft and not onback and not onright:
								var instanceslope =currentdata.slope2_mesh.instantiate()
								add_child(instanceslope)
								instanceslope.global_position=global_position+(Vector3(size3X3.x*X*Xmultiplier,(size3X3.y*(Y+1))*Yval*Ymultiplier,size3X3.z*Z))
								instanceslope.global_scale(Vector3(1,Yval*Ymultiplier,1*Xmultiplier))
								instanceslope.rotate_y(deg_to_rad(-90))
							elif onfront and onright  and not onback and not onleft:
								var instanceslope =currentdata.slope2_mesh.instantiate()
								add_child(instanceslope)
								instanceslope.global_position=global_position+(Vector3(size3X3.x*X*Xmultiplier,(size3X3.y*(Y+1))*Yval*Ymultiplier,size3X3.z*Z))
								instanceslope.global_scale(Vector3(1*Xmultiplier,Yval*Ymultiplier,1))
							elif onback and onright  and not onfront and not onleft:
								var instanceslope =currentdata.slope2_mesh.instantiate()
								add_child(instanceslope)
								instanceslope.global_position=global_position+(Vector3(size3X3.x*X*Xmultiplier,(size3X3.y*(Y+1))*Yval*Ymultiplier,size3X3.z*Z))
								instanceslope.global_scale(Vector3(1,Yval*Ymultiplier,1*Xmultiplier))
								instanceslope.rotate_y(deg_to_rad(90))
							elif onback and onleft  and not onfront and not onright:
								var instanceslope =currentdata.slope2_mesh.instantiate()
								add_child(instanceslope)
								instanceslope.global_position=global_position+(Vector3(size3X3.x*X*Xmultiplier,(size3X3.y*(Y+1))*Yval*Ymultiplier,size3X3.z*Z))
								instanceslope.global_scale(Vector3(1*Xmultiplier,Yval*Ymultiplier,1))
								instanceslope.rotate_y(deg_to_rad(180))
							

							elif not onback and not onleft and not onfront and not onright:
								if frontright and not frontleft and not backleft and not backright:
									
									var instanceslope =currentdata.Slopecorner_mesh.instantiate()
									add_child(instanceslope)
									instanceslope.global_position=global_position+(Vector3(size3X3.x*X*Xmultiplier,(size3X3.y*(Y+1))*Yval*Ymultiplier,size3X3.z*Z))
									instanceslope.global_scale(Vector3(1*Xmultiplier,Yval*Ymultiplier,1))
									#instanceslope.rotate_y(deg_to_rad(180))
								elif frontleft and not frontright and not backleft and not backright:
									var instanceslope =currentdata.Slopecorner_mesh.instantiate()
									add_child(instanceslope)
									instanceslope.global_position=global_position+(Vector3(size3X3.x*X*Xmultiplier,(size3X3.y*(Y+1))*Yval*Ymultiplier,size3X3.z*Z))
									instanceslope.global_scale(Vector3(1,Yval*Ymultiplier,1*Xmultiplier))
									instanceslope.rotate_y(deg_to_rad(-90))
								elif backleft and not frontleft and not frontright and not backright:
									var instanceslope =currentdata.Slopecorner_mesh.instantiate()
									add_child(instanceslope)
									instanceslope.global_position=global_position+(Vector3(size3X3.x*X*Xmultiplier,(size3X3.y*(Y+1))*Yval*Ymultiplier,size3X3.z*Z))
									instanceslope.global_scale(Vector3(1*Xmultiplier,Yval*Ymultiplier,1))
									instanceslope.rotate_y(deg_to_rad(180))
								elif backright and not frontright and not backleft and not frontleft:
									var instanceslope =currentdata.Slopecorner_mesh.instantiate()
									add_child(instanceslope)
									instanceslope.global_position=global_position+(Vector3(size3X3.x*X*Xmultiplier,(size3X3.y*(Y+1))*Yval*Ymultiplier,size3X3.z*Z))
									instanceslope.global_scale(Vector3(1,Yval*Ymultiplier,1*Xmultiplier))
									instanceslope.rotate_y(deg_to_rad(90))
								elif backleft and frontright and not backright and not frontleft:
									var instanceslope =currentdata.slopediagonal.instantiate()
									add_child(instanceslope)
									instanceslope.global_position=global_position+(Vector3(size3X3.x*X*Xmultiplier,(size3X3.y*(Y+1))*Yval*Ymultiplier,size3X3.z*Z))
									instanceslope.global_scale(Vector3(1*Xmultiplier,Yval*Ymultiplier,1))
								elif backright and frontleft and not backleft and not frontright:
									var instanceslope =currentdata.slopediagonal.instantiate()
									add_child(instanceslope)
									instanceslope.global_position=global_position+(Vector3(size3X3.x*X*Xmultiplier,(size3X3.y*(Y+1))*Yval*Ymultiplier,size3X3.z*Z))
									instanceslope.global_scale(Vector3(1,Yval*Ymultiplier,1*Xmultiplier))
									instanceslope.rotate_y(deg_to_rad(90))
									
										
						var instance =currentdata.top_mesh.instantiate()
						add_child(instance)
						instance.global_position=global_position+(Vector3(size3X3.x*X*Xmultiplier,(size3X3.y*Y)*Yval*Ymultiplier,size3X3.z*Z))
						instance.global_scale(Vector3(1*Xmultiplier,Yval*Ymultiplier,1))

				analyzedgrid[X].append(cuts)

		
	
						
