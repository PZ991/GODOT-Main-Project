extends CharacterBody3D

class_name Player

enum {Move, Climb,Freeze}
#Basics

@export  var playerdata: Player_Movement_Data #Resource
@export var buffered_jump=false
@export var coyotejump=false

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

@onready var laddercheck= $Laddercheck
@onready var jumpbuffer = $JumpBuffer
@onready var coyotejumpTimer=$CoyoteJumpTimer
@onready var remoteTranforrm = $RemoteTransform3D
@onready var animator = $AnimatedSprite3D
@onready var tile_finder:TileFinder = $TileFinder


#var test2= preload("res://Powers/Earth/Wall/small_rock_wall.tscn")
var state = Move

var double_jump=1


var lefttapCount = 0
var attacktapCount = 0
var righttapCount = 0
var leftdashdoubleTapTime = 1
var rightdashdoubleTapTime = 1
var dashing = false

@export var Skill1:ComboData
@export var Skill2:ComboData
@export var Skill3:ComboData
@export var Skill4:ComboData
@export var Skill5:ComboData
@export var Skill6:ComboData
@export var Skill7:ComboData
@export var Skill8:ComboData

var currentanima:ComboData

var facingleft=false


var viewport = null

var mouse_position =Vector3.ZERO

var mouse_position_3D=Vector3.ZERO
@onready var camera = $Camera3D

func _ready():
	viewport=get_viewport()
	mouse_position =viewport.get_mouse_position()
	camera=viewport.get_camera_3d()
	
func _physics_process(delta):

	#if Input.is_action_just_pressed("Jump"):
	#	print("start")
	#if Input.is_action_pressed("Jump"):
	#	print("hold")
	#if Input.is_action_just_released("Jump"):
	#	print("end")

	mouse_position_3D = ScreenPointToRay()

	FaceMouse()
	
	SkillInput()
		
	handledash(delta)
	
	var input = Vector3.ZERO
	input.x = Input.get_axis("Move Left", "Move Right")
	input.z = Input.get_axis("Move Up", "Move Down")
	
	gravity=-9.18
	if not is_on_floor():
		animator.play("Jump")
		velocity.y += gravity * delta
	
	if not dashing:
		match state:
			Move: handlemovement(delta,input)
			Climb:climbstate(input)
	else:

		animatedash(input)

	move_and_slide()


		#Movement Handlers#



#player movement
func handlemovement(delta, direction):
	
	if is_onladder() and Input.is_action_pressed("Move Up"):
		state=Climb
		return
	if Input.is_key_pressed(KEY_CTRL):
		crouch()
		return
	
	handlejump(delta)
	
	

	if direction:
		if Input.is_key_pressed(KEY_SHIFT) and ((not facingleft and direction.x<0)or( facingleft and direction.x>0)):
			animator.play("Run")
			velocity.x = direction.x *playerdata. SPEED*2
		else:
			if (not animator.flip_h and direction.x>0) or(  animator.flip_h and direction.x<0) :
				animator.play("Jog")
				velocity.x = direction.x * playerdata.SPEED
			if (not animator.flip_h and direction.x<0) or( animator.flip_h and direction.x>0) :
				animator.play("Jog_Backward")
				velocity.x = direction.x * playerdata.SPEED/2
			
			elif(direction.z!=0):
				animator.play("Jog")
				velocity.z = direction.z * playerdata.SPEED
		
		
		
	else:
		animator.play("Idle")
		velocity.x = move_toward(velocity.x, 0, playerdata.SPEED)
		velocity.z = move_toward(velocity.z, 0, playerdata.SPEED)
		

#player jump, coyote jump, buffered jump
func handlejump(delta):
	
	# Add the gravity.
	
	# Handle Jump.
	if is_on_floor() or coyotejump:
		double_jump=1
		if Input.is_action_just_pressed("Jump") or buffered_jump:
			print(playerdata.JUMP_VELOCITY)
			SoundPlayer.playsound(SoundPlayer.Jump)
			velocity.y = playerdata.JUMP_VELOCITY
			buffered_jump=false
	else:
		if Input.is_action_just_pressed("Jump") and double_jump>0:
			SoundPlayer.playsound(SoundPlayer.Jump)
			
			velocity.y = playerdata.JUMP_VELOCITY
			double_jump-=1
		if Input.is_action_just_pressed("Jump"):
			SoundPlayer.playsound(SoundPlayer.Jump)
			buffered_jump=true;
			jumpbuffer.start()
	
	var wasinair=not is_on_floor()
	var wasonfloor= is_on_floor()
	var justlanded= is_on_floor() and wasinair
	if justlanded:
		animator.play("Run")
		animator.frame=1;
	var justleftground = not is_on_floor() and wasonfloor
	if justleftground and velocity.y>=0:
		coyotejump=true
		coyotejumpTimer.start()
	move_and_slide()


#crouch movement
func crouch():
	animator.play("Crouch")

#player climb ladder
func climbstate(input):
	if input.y!=0 : $AnimatedSprite2D.animation="Run"
	else: $AnimatedSprite2D.animation="Idle"
	velocity=input*playerdata.climbspeed
	gravity=0

	if not is_onladder(): state = Move
	pass

#is on ladder
func is_onladder():
	if not laddercheck.is_colliding(): return false
	var collider = laddercheck.get_collider()
	if not collider is Ladder: return false
	return true


		#Secondary Handlers#


#make character face moude
func FaceMouse():
	
	var origin = camera.project_ray_origin(mouse_position)
	var direction = camera.project_ray_normal(mouse_position)

	if(mouse_position_3D.x< position.x):
		facingleft=false
	if(mouse_position_3D.x> position.x):
		facingleft=true
		
	if facingleft:
		animator.flip_h=false
	if not facingleft:
		animator.flip_h=true

#Skills with special input
func SkillInput():
	if(Input.is_action_just_pressed("Skill E")):
		state=Freeze
		animator.play(Skill1.animationname)
		currentanima=Skill1
	if(Input.is_action_just_pressed("Skill Q")):
		state=Freeze
		animator.play(Skill2.animationname)
		currentanima=Skill2
	if(Input.is_action_just_pressed("Skill C")):
		state=Freeze
		animator.play(Skill3.animationname)
		currentanima=Skill3

#double tap with input, tapcount handler, time decay and boolean
func handleDoubleTap(stringinput, tapCount,  dashDoubleTapTime,  isDashing, delta):
	if Input.is_action_just_pressed(stringinput):
		tapCount += 1
		if tapCount == 1:
			dashDoubleTapTime = 1
		elif tapCount == 2 and dashDoubleTapTime > 0:
			isDashing = true
			tapCount = 0
		elif tapCount > 2 or dashDoubleTapTime <= 0:
			tapCount = 0
	elif (Input.is_anything_pressed() ) and not Input.is_action_pressed(stringinput):
		tapCount=0
	else:
		dashDoubleTapTime = max(0, dashDoubleTapTime - delta)
	
	return [tapCount, dashDoubleTapTime, isDashing]

#dash from using douwble tap
func handledash(delta):
	var handleleft=handleDoubleTap("Move Left",lefttapCount,leftdashdoubleTapTime,dashing,delta)
	lefttapCount=handleleft[0]
	leftdashdoubleTapTime=handleleft[1]
	dashing=handleleft[2]
	var handleright=handleDoubleTap("Move Right",righttapCount,rightdashdoubleTapTime,dashing,delta)
	righttapCount=handleright[0]
	rightdashdoubleTapTime=handleright[1]
	dashing=handleright[2]

#handle dash animation
func animatedash(direction):
	
	if ( facingleft and direction.x>0) or(not facingleft and direction.x<0) :
		animator.play("Dash_Forward")
	if ( facingleft and direction.x<0) or(not facingleft and direction.x>0) :
		animator.play("Dash_Backward")

	move_and_collide(Vector3(0.25*direction.x,0,0))
	if animator.frame==2:
	#if $AnimatedSprite2D.animation=="Dash_Forward" or $AnimatedSprite2D.animation=="Dash_Backward":
		dashing = false

#when animation is finished for non-loop animations
func _on_animated_sprite_3d_animation_finished():

	if(not currentanima== null):
		
		if(currentanima.instantiatefinished):
			
			var instance = currentanima.instances[0].instances.instantiate()
			#var n= test2.instantiate()
			#get_parent().add_child(n)
			var world = get_tree().current_scene
			world.add_child(instance)
			#get_parent().add_child(n)
			if(not currentanima.instances[0].onmouse and currentanima.instances[0].static_move):
				
				instance.global_position=global_position+currentanima.instances[0].offset
				print(instance.global_position)
				if(currentanima.instances[0].orientXaxis):
					if( facingleft):
						instance.direction=Vector2.RIGHT*5
					if(not facingleft):
						instance.direction=Vector2.LEFT*5
			elif( currentanima.instances[0].onmouse and  currentanima.instances[0].closestground):
				tile_finder.global_position=ScreenPointToRay()
				tile_finder.RADIUS=currentanima.instances[0].mousedistance
				tile_finder.ChangeRadius()
				var pos = tile_finder.ProcessRaycasts()
				if(not pos == Vector3.ZERO):
					instance.global_position=pos
			elif currentanima.instances[0].stationary:
				instance.global_position=global_position+currentanima.instances[0].offset
			
			if(currentanima.instances[0].orientXaxis):
				if(not facingleft):
					instance.scale=Vector3(-1,1,1)
					
		if(currentanima.returntodefault):

			state=Move
			currentanima=null
			
	pass # Replace with function body.

		#Other Functions#


#find camera and connect to player
func connectcam(cam):
	var camerapath= cam.get_path()
	remoteTranforrm.remote_path=camerapath

#timer jump buffer
func _on_jump_buffer_timeout():
	buffered_jump=false
	pass # Replace with function body.

#timer coyote jump
func _on_coyote_jump_timer_timeout():
	coyotejump=false
	pass # Replace with function body.

#player dies
func PlayerDeath():
	SoundPlayer.playsound(SoundPlayer.Hurt)
	queue_free()
	#get_tree().reload_current_scene()
	Events.emit_signal("playerdied")

func ScreenPointToRay():
	var spacestate= get_world_3d().direct_space_state
	var camera = get_viewport().get_camera_3d()
	var mousepos=get_viewport().get_mouse_position()
	var rayorigin = camera.project_ray_origin(mousepos)
	var rayend = rayorigin+camera.project_ray_normal(mousepos)*2000
	var rayarray= spacestate.intersect_ray(PhysicsRayQueryParameters3D.create( rayorigin,rayend))
	if rayarray.has("position"):
		return rayarray["position"]
	return rayend



