extends CharacterBody3D

class_name PlayerV3

enum {Climb,Freeze,Jog,Run,Idle,Jump,DoubleJump,Falling,Immobile,Slowdown,Dash,MoveFix,LedgeGrab,LedgeUp,LedgeJump,WallRun,Push}
enum {Stand,Crouch,Prone,Swim,Fly}
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
@onready var shape_cast_3d2 = $ShapeCast3D

@onready var dash_timer = $DashTimer

@onready var fall_timer = $FallTimer
@onready var immobilize_timer = $ImmobilizeTimer

var falling =false
var fallinghard=false


var state = Idle
var stance = Stand
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
var skillinstanced=false

var facingleft=false


var viewport = null

var mouse_position =Vector3.ZERO

var mouse_position_3D=Vector3.ZERO
@onready var camera = $Camera3D
@onready var shape_cast_3d = $Fade/ShapeCast3D2
@onready var buildcursor= $Fade
@export var WOOD : PackedScene


var isbuilding=false
var buildist=0.0
var buildlock=false
var lockX=false
var lockY=false
var lockZ=false
var lockpos=Vector3.ZERO
var lastinteractables=[]


var freezetilanimationdone=false
var wasinair=false
var justlanded=false
var wasonfloor=false
var landingimmobile=0.5
var hardlandingimmobile=1
var previousanimation=""
var facingdirectionmousewithinput=false
var allowdash=true
var dashstarted=false

@onready var head_on_wall = $"Head on wall"
@onready var body_on_wall = $"Body on wall"
var immobilevalue=0
var allowgrab=true
var climbtime=1
var lockdirection=false
var walljumped=false
var wallruntime=3
var wallclimbing=false
var wallclimbdecay=0.05
var wallclimbingspeed=4
var jumpvelocityX=0.0
var allowaircontrol=false
#walljumpremovetimerlock, walljumptimer
func _ready():
	viewport=get_viewport()
	mouse_position =viewport.get_mouse_position()
	camera=viewport.get_camera_3d()
	
func _physics_process(delta):
	
	if Input.is_action_just_pressed("Build"):
		isbuilding=!isbuilding
	
	if not isbuilding and not camera.activecam:
		buildist=0
		buildcursor.visible=false

		#SkillInput()
	elif isbuilding:
		if Input.is_action_just_pressed("Middle Mouse"):
			buildlock=!buildlock
			if Input.get_action_strength("Run"):
				lockpos=global_position
			else:
				lockpos=buildcursor.global_position
		if buildlock:
			if Input.is_action_just_pressed("X"):
				lockX=!lockX
			if Input.is_action_just_pressed("Y"):
				lockY=!lockY
			if Input.is_action_just_pressed("Z"):
				lockZ=!lockZ
			
		buildcursor.scale=(Vector3.ONE*6.2*0.333)
		buildcursor.visible=true

		buildmode()

	if camera.activecam:
		return
	
	mouse_position_3D = ScreenPointToRay()
	
	if not state==LedgeGrab and not lockdirection:
		FaceMouse()
	

	
	var input = Vector3.ZERO
	input.x = Input.get_axis("Move Left", "Move Right")
	input.z = Input.get_axis("Move Up", "Move Down")
	
	
	if not is_on_floor() and not (falling or fallinghard) and not state == LedgeUp and not state==LedgeGrab and not state==WallRun and not state==Climb :
		animator.play("Jump")
		
	
	if not state == LedgeUp and not state==LedgeGrab and not state==WallRun and not state==Climb:
		ApplyGravity(delta)
	
	if not state==Immobile and not state == Slowdown and not state==MoveFix and not state == LedgeUp and not state==LedgeGrab and not state==Climb :
		HandleInputs(delta,input)
	

	match state:
			
		Climb:ClimbHandler(input)
		Freeze: FreezeHandler(delta)
		Jog:JogHandler(delta,input)
		Run:RunHandler(delta,input)
		Idle:IdleHandler()
		Dash:DashHandler(input)
		Jump:JumpHandler()
		DoubleJump:DoubleJumpHandler()
		Falling:FallingHandler()
		Immobile:Immobilize()
		Slowdown:SlowdownHandler(immobilevalue)#0.001
		MoveFix:MoveFixHandler(immobilevalue,input)#8
		LedgeGrab:LedgeGrabHandler()
		LedgeUp:LedgeUpHandler(10)
		LedgeJump:LedgeJumpHandler()
		Push:PushHandler()
		WallRun:WallrunHandler(4)
	
	move_and_slide()

func LedgeUpHandler(distance):
	velocity.y=1.5
	
	


func LedgeGrabHandler():
	velocity=Vector3.ZERO
	animator.play("Ledge Grab")
	lockdirection=true
	if Input.is_action_pressed("Move Up"):
		animator.play("LedgeUp")
		state= LedgeUp
		allowgrab=false
		immobilize_timer.wait_time=climbtime
		immobilize_timer.start()
		jumpvelocityX=0
		return

	

func Immobilize():
	velocity=Vector3.ZERO

func SlowdownHandler(slowdownspeed):
	velocity.x = move_toward(velocity.x, 0, slowdownspeed)
	velocity.z = move_toward(velocity.z, 0, slowdownspeed)

func MoveFixHandler(distance,input):
	if not lockdirection:
		velocity.x = distance*input.x
	else:
		velocity.x =distance*velocity.normalized().x
	

func DashDetect(delta,direction):
	if allowdash==true:
		var handleleft=handleDoubleTap("Move Left",lefttapCount,leftdashdoubleTapTime,dashing,delta)
		lefttapCount=handleleft[0]
		leftdashdoubleTapTime=handleleft[1]
		dashing=handleleft[2]
		var handleright=handleDoubleTap("Move Right",righttapCount,rightdashdoubleTapTime,dashing,delta)
		righttapCount=handleright[0]
		rightdashdoubleTapTime=handleright[1]
		dashing=handleright[2]
		if dashing :
			lefttapCount=0
			leftdashdoubleTapTime=0
			righttapCount=0
			rightdashdoubleTapTime=0
			state=Dash
			dash_timer.start()
			allowdash=false
			dashstarted=false
			

func PushHandler():
	if velocity.x==0:
		velocity.z=move_toward(velocity.z, 0, playerdata.SPEED)
		animator.play("Push Idle")

func WallrunHandler(speed):
	
	animator.play("WallRun")
	if wallclimbdecay!=0:
		velocity.y=move_toward(velocity.y, 0, wallclimbdecay)
		if velocity.y==0:
			state=Idle
		if Input.is_action_just_pressed("Jump") and double_jump>0:
			velocity.y = playerdata.JUMP_VELOCITY
			lockdirection=true
			allowaircontrol=false
			facingleft=!facingleft
			animator.flip_h=!animator.flip_h
			if facingleft:
				velocity.x= playerdata.JUMP_VELOCITY
			else:
				velocity.x= -playerdata.JUMP_VELOCITY
			double_jump-=1
			state=DoubleJump
			fall_timer.start()
			walljumped=true
			
	
func HandleInputs(delta,direction):
	
	facingdirectionmousewithinput= ((not facingleft and direction.x<0)or( facingleft and direction.x>0))or (direction.x==0 and direction.z!=0)
	var facingdirectionwithinputonly= ((not facingleft and direction.x<0)or( facingleft and direction.x>0))
	
	if (facingdirectionmousewithinput or Input.get_action_strength("Move Up") )and laddercheck.is_colliding():
		print("climb")
		global_position.x=laddercheck.get_collider().global_position.x
		state=Climb
		return
	
	if is_on_floor():
		

		wasonfloor=true
		
		DashDetect(delta,direction)
			
		if dashing:	
			return
		#endregion
		
		if wasinair:
			justlanded= true
			wasinair=false
			wasonfloor=false
		
		if direction:

			
			if (not head_on_wall.is_colliding() and not body_on_wall.is_colliding() )or not facingdirectionwithinputonly:
				if Input.get_action_strength("Run") and facingdirectionmousewithinput :
					state=Run
				else:
					state=Jog
			else:
				state=Push
		else:
			state=Idle
			
		if is_onladder() and Input.is_action_pressed("Move Up"):
			state=Climb
		
		if Input.is_action_just_pressed("Crouch"):
			if stance==Stand:
				stance=Crouch
			elif stance==Crouch:
				stance=Stand
		
		if not head_on_wall.is_colliding() and not body_on_wall.is_colliding():
			if (Input.is_action_just_pressed("Jump") and buffered_jump==false):
				velocity.y = playerdata.JUMP_VELOCITY
				state=Jump
				
				allowaircontrol=true
				if Input.get_action_strength("Run"):
					wallclimbing=true
				else:
					wallclimbing=false
			if facingdirectionmousewithinput:
				jumpvelocityX=velocity.x
			else:
				jumpvelocityX=velocity.x/2
			
		else:
			if (Input.is_action_just_pressed("Jump") and buffered_jump==false):
				print("ledgejump")
				velocity.y = playerdata.JUMP_VELOCITY
				state=LedgeJump
				allowaircontrol=false
	else:
		if allowaircontrol:
			if facingdirectionmousewithinput:
				velocity.x = jumpvelocityX+(direction.x*(playerdata. SPEED/3))
			else:
				velocity.x = jumpvelocityX+(direction.x*(playerdata. SPEED/5))
		else:
			jumpvelocityX=0
		dashing=false
		if allowgrab==true:
			if not head_on_wall.is_colliding() and body_on_wall.is_colliding():
				state=LedgeGrab
				animator.play("Ledge Grab")
				allowaircontrol=false
				immobilize_timer.stop()
				return
		
		if head_on_wall.is_colliding() and body_on_wall.is_colliding() and wallclimbing:
			state=WallRun
			immobilize_timer.wait_time=wallruntime
			immobilize_timer.start()
			velocity.y=wallclimbingspeed
			wallclimbing=false
		
		if state==WallRun:
			return
		
		if (Input.is_action_just_pressed("Jump") and not buffered_jump) and coyotejump :
			velocity.y = playerdata.JUMP_VELOCITY
			state=Jump
		elif Input.is_action_just_pressed("Jump") and double_jump>0:
			velocity.y = playerdata.JUMP_VELOCITY
			double_jump-=1
			state=DoubleJump
			fall_timer.start()
		
		if fall_timer.time_left <(fall_timer.wait_time/2) and wasinair:
			falling=true
			if  fall_timer.time_left<=0:
				
				fallinghard=true
			state=Falling
		#print(fall_timer.time_left)
		if not wasinair:
			fall_timer.start()
			allowgrab=true
			wasinair=true

	
	if justlanded:
		#print("landed")
		double_jump=1
		
		if fallinghard:
			#print("hard")
			animator.play("Hard Land 2")
			
			SetImmobilizeTimer("Hard Land 2",hardlandingimmobile,Immobile,0)
			
		elif falling:
			#print("soft")
			if velocity.x!=0:
				SetImmobilizeTimer("Roll",landingimmobile,MoveFix,8)
				lockdirection=true
			else:
				SetImmobilizeTimer("Hard Land 2",landingimmobile,Immobile,0)
			
		
		ResetFall()

		
	var justleftground = not is_on_floor() and wasonfloor
	if justleftground and velocity.y>=0:
		
		double_jump=1
		fall_timer.start()
		if not buffered_jump:
			coyotejump=true
		coyotejumpTimer.start()
		wasonfloor=false
			
		
			

	
	move_and_slide()

func SetImmobilizeTimer(animationname,wait_time,newstate,newimmobilevalue):
	animator.play(animationname)
	state=newstate
	immobilize_timer.wait_time=wait_time
	immobilize_timer.start()
	if newstate==MoveFix:
		immobilevalue=newimmobilevalue
	elif newstate==Slowdown:
		immobilevalue=newimmobilevalue
	else:
		immobilevalue=0

func ResetFall():
	falling=false
	fallinghard=false
	fall_timer.stop()
	justlanded=false

func ApplyGravity(delta):
	gravity=-9.18
	velocity.y += gravity * delta

		#Movement Handlers#

func FreezeHandler(delta):
	
	if is_on_floor() and not justlanded and not falling and not fallinghard:
		animator.play("Idle")
		velocity.x =0
		velocity.z = 0
		
	elif not is_on_floor():
		velocity.x = 0
		velocity.z =0
		

func RunHandler(delta,direction):
	if stance==Stand:
		animator.play("Run")
		velocity.x = direction.x *playerdata. SPEED*2
	elif stance==Crouch:
		animator.play("Crouch Run")
		velocity.x = direction.x *playerdata. SPEED

func JumpHandler():
	animator.play("Jump")
	coyotejump=false
	jumpbuffer.start()
	buffered_jump=true;
	

func LedgeJumpHandler():
	animator.play("Ledge Jump")
	coyotejump=false
	jumpbuffer.start()
	buffered_jump=true;
	wallclimbing=false
	
	
func FallingHandler():
	animator.play("Jump Fall")
func DoubleJumpHandler():
	animator.play("Double Jump")
#player movement

func JogHandler(delta,direction):
	if stance==Stand:
		if facingdirectionmousewithinput:
			animator.play("Jog")
			velocity.x = direction.x *playerdata. SPEED
			
			velocity.z = direction.z * playerdata.SPEED
		else:
			animator.play("Jog_Backward")
			velocity.x = direction.x *playerdata. SPEED/2
			velocity.z = direction.z * playerdata.SPEED
	elif stance==Crouch:
		animator.play("Crouch Walk")
		velocity.x = direction.x *playerdata. SPEED/2
		velocity.z = direction.z * playerdata.SPEED/3
		
func DashHandler(direction):

	if dashstarted==false:
		if facingdirectionmousewithinput :
			animator.play("Dash_Forward")
		else :
			animator.play("Dash_Backward")
		dashstarted=true

	move_and_collide(Vector3(0.25*direction.x,0,0))
	if animator.frame==2:
		#state=Idle
		dashing=false
func IdleHandler():
	if stance==Stand:
		animator.play("Idle")
	elif stance==Crouch:
		animator.play("Crouch")
	velocity.x = move_toward(velocity.x, 0, playerdata.SPEED)
	velocity.z = move_toward(velocity.z, 0, playerdata.SPEED)

#crouch movement
func CrouchHandler():
	
	animator.play("Crouch")

#player climb ladder
func ClimbHandler(input):
	
	
	
	
	if not laddercheck.is_colliding():
		state=Jump
		fall_timer.start()
	else:
		print(laddercheck.get_collider().name)
		if laddercheck.get_collider().name=="Rope":
		
			if input.x!=0 : animator.play("Rope Climb")
			else: animator.play("Rope Idle")

		elif laddercheck.get_collider().name=="Ladder":
			if input.x!=0 : animator.play("WallRun")
			else: animator.play("WallCling")
		
		velocity.y=input.x*playerdata.climbspeed
		allowaircontrol=false
		velocity.x=0
		velocity.z=0
		falling=false
		fallinghard=false
		
		if is_on_floor() and input.x<0:
			state=Idle
		
		if (Input.is_action_just_pressed("Jump") and buffered_jump==false):
			velocity.y = playerdata.JUMP_VELOCITY
			
			if facingleft:
				velocity.x=playerdata.JUMP_VELOCITY
			else:
				velocity.x=-playerdata.JUMP_VELOCITY
			state=Jump
			fall_timer.start()

			if Input.get_action_strength("Run"):
				wallclimbing=true
			else:
				wallclimbing=false


	#if not is_onladder(): state = Jog
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
		head_on_wall.target_position=Vector3(-0.25,0,0)
		body_on_wall.target_position=Vector3(-0.25,0,0)
		laddercheck.target_position=Vector3(-0.25,0,0)
		laddercheck.position.x=0.226
		
	if(mouse_position_3D.x> position.x):
		facingleft=true
		head_on_wall.target_position=Vector3(0.25,0,0)
		body_on_wall.target_position=Vector3(0.25,0,0)
		laddercheck.target_position=Vector3(0.25,0,0)
		laddercheck.position.x=-0.226
		
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
	if(Input.is_action_just_pressed("Normal Combo")):
		state=Freeze
		animator.play(Skill4.animationname)
		currentanima=Skill4
	if(Input.is_action_just_pressed("Skill Z")):
		state=Freeze
		animator.play(Skill5.animationname)
		currentanima=Skill5
	

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




#when animation is finished for non-loop animations



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
	var rayend = rayorigin+camera.project_ray_normal(mousepos)*20
	var rayarray= spacestate.intersect_ray(PhysicsRayQueryParameters3D.create( rayorigin,rayend,11))
	if rayarray.has("position"):
		var vectora:Vector3= round_to_grid(rayarray["position"],Vector3(1,1,1)*0.333,true,true,true)
		var vectorb:Vector3 = rayarray["collider"].global_position-(Vector3(0,1,0)*0.333)
		#print( str ( vectorb) + "," + str( vectora) )
		if(is_equal_approx(vectora.x,vectorb.x)):
			if(is_equal_approx(vectora.x,vectorb.x)):
				if(is_equal_approx(vectora.y,vectorb.y)):
					if(is_equal_approx(vectora.z,vectorb.z)):
					
						return rayarray["position"]+(rayarray["normal"]*0.333)

		return rayarray["position"]
	else:
		rayend = rayorigin+camera.project_ray_normal(mousepos)*(camera.global_position.z+buildist)
		
	return rayend


func buildmode():
	
	var raypos= ScreenPointToRay()
	if buildlock:
		if lockZ:
			raypos.z=clamp(lockpos.z+buildist,-4,4)
		if lockX:
			raypos.x=lockpos.x+buildist
		if lockY:
			raypos.y=lockpos.y+buildist
	
	var finalpos=round_to_grid(raypos,Vector3(1,1,1)*0.333,true,true,true)
#if (shape_cast_3d.is_colliding()):
		#finalpos=round_to_grid(,Vector3(1,1,1)*0.333,true,true,true)
	buildcursor.global_position=finalpos

	

func round_to_grid(input_vector: Vector3,gridsize:Vector3,ClampX:bool,ClampY:bool,ClampZ:bool) -> Vector3:
	var rounded_vector = input_vector
	if ClampX:
		rounded_vector.x = round(input_vector.x / gridsize.x) * gridsize.x
	if ClampY:
		rounded_vector.y = round(input_vector.y / gridsize.y) * gridsize.y
	if ClampZ:
		rounded_vector.z = round(input_vector.z / gridsize.z) * gridsize.z
	return rounded_vector

func _on_animated_sprite_3d_frame_changed():
	if not currentanima==null:
		if not currentanima.instantiatefinished:
			if currentanima.instances.size()>0:
				if animator.frame>=currentanima.instantiateframe:
					var instance = currentanima.instances[0].instances.instantiate()

					#var n= test2.instantiate()
					#get_parent().add_child(n)
					var world = get_tree().current_scene
					world.add_child(instance)
					#get_parent().add_child(n)
					if(not currentanima.instances[0].onmouse and currentanima.instances[0].static_move and not currentanima.instances[0].MoveStayLocation):
						
						instance.global_position=global_position+currentanima.instances[0].offset

						if(currentanima.instances[0].orientXaxis):
							if( facingleft):
								instance.direction=Vector3.RIGHT*5
							if(not facingleft):
								instance.direction=Vector3.LEFT*5
					elif( currentanima.instances[0].onmouse and  currentanima.instances[0].closestground):
						tile_finder.global_position=ScreenPointToRay()
						tile_finder.RADIUS=currentanima.instances[0].mousedistance
						tile_finder.ChangeRadius()
						var pos = tile_finder.ProcessRaycasts()
						if(not pos == Vector3.ZERO):
							instance.global_position=pos
					elif currentanima.instances[0].stationary:
						
						instance.global_position=global_position+currentanima.instances[0].offset

					elif currentanima.instances[0].MoveStayLocation:
							instance.startpos=global_position
							instance.target_pos=currentanima.instances[0].offset
							instance.speed=currentanima.instances[0].speed

					if(currentanima.instances[0].orientXaxis):
						if(not facingleft):
							
							instance.scale=instance.scale*Vector3(-1,1,1)
					
			
	pass # Replace with function body.

var leftclicked=false
func _input(event):
	if buildmode and isbuilding:
		if event is InputEventMouseButton:
			if event.button_index == MOUSE_BUTTON_WHEEL_UP and event.pressed:
				buildist+=0.3333



			if event.button_index == MOUSE_BUTTON_WHEEL_DOWN and event.pressed:
				buildist-=0.3333

			
			if event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed:
				if not leftclicked:
					leftclicked=true
					var newwood= WOOD.instantiate()
					var world = get_tree().current_scene
					world.add_child(newwood)
					newwood.global_position=buildcursor.global_position+(Vector3(0,1,0)*0.333)
					newwood.scale= Vector3.ONE*0.333
			
				elif event.is_released and event.button_index == MOUSE_BUTTON_LEFT:
					leftclicked=false
					return

			
func processinteraction():
	
	var interactions=shape_cast_3d2.collision_result

	for objects in interactions:
		var collider = objects["collider"]
		if "directionaldestroyed" in collider:
			if lastinteractables.has("Boulder"):
				collider.directionaldestroy=true





func _on_fall_timer_timeout():
	falling=false
	fallinghard=true
	
	#print("falling")
	
	pass # Replace with function body.


func _on_heavy_fall_timer_timeout():
	falling=false
	fallinghard=true
	animator.play("Jump Fall")
	#print("hard falling")
	
	pass # Replace with function body.


func _on_animated_sprite_3d_animation_changed():
	#print(animator.animation)

	pass
func _on_animated_sprite_3d_animation_finished():
	
		
	if previousanimation!=animator.animation:
		previousanimation=animator.animation
		
		if previousanimation=="Hard Land 2":
			
			if falling or fallinghard :
				state==Idle
				falling=false
				fallinghard=false

	
	if(not currentanima== null):
		
		if(currentanima.instantiatefinished):
			
			var instance = currentanima.instances[0].instances.instantiate()

			#var n= test2.instantiate()
			#get_parent().add_child(n)
			var world = get_tree().current_scene
			world.add_child(instance)
			#get_parent().add_child(n)
			if(not currentanima.instances[0].onmouse and currentanima.instances[0].static_move and not  currentanima.instances[0].MoveStayLocation):
				
				instance.global_position=global_position+currentanima.instances[0].offset
				
				if(currentanima.instances[0].orientXaxis):
					if(not facingleft):
						instance.scale*=Vector3(1,1,-1)
				
			elif( currentanima.instances[0].onmouse and  currentanima.instances[0].closestground):
				tile_finder.global_position=ScreenPointToRay()
				tile_finder.RADIUS=currentanima.instances[0].mousedistance
				tile_finder.ChangeRadius()
				var pos = tile_finder.ProcessRaycasts()
				if(not pos == Vector3.ZERO):
					instance.global_position=pos
			elif currentanima.instances[0].stationary:
				
				instance.global_position=global_position+currentanima.instances[0].offset

			elif currentanima.instances[0].MoveStayLocation:
				
				var Xposoffset=currentanima.instances[0].offset
				var Xpostarget=currentanima.instances[0].TargetLocation
				
				if(currentanima.instances[0].orientXaxis):
					if(not facingleft):
						Xposoffset*=Vector3(-1,1,1)
						Xpostarget*=Vector3(-1,1,1)
				instance.global_position=global_position+Xposoffset
				instance.startpos=global_position
				instance.target_pos=Xpostarget
				instance.speed=currentanima.instances[0].speed

			if(currentanima.instances[0].orientXaxis):
				if(not facingleft):
					instance.scale=instance.scale*Vector3(-1,1,1)
			
		if(currentanima.activateInteracter):
			if(currentanima.activateinteractionfinished):
				lastinteractables=currentanima.interactorinteractables
				processinteraction()



				
		if(currentanima.returntodefault):
			state=Idle
			currentanima=null
			




func _on_animated_sprite_3d_animation_looped():
	if previousanimation!=animator.animation:
		previousanimation=animator.animation
		#print("loop changed")
	pass # Replace with function body.


func _on_dash_timer_timeout():
	allowdash=true
	pass # Replace with function body.


func _on_immobilize_timer_timeout():
	if state== WallRun:
		wallclimbing=false
	if state==LedgeUp:
		print("doe up")
		allowaircontrol=true
		if facingleft:
			jumpvelocityX=1
		else:
			jumpvelocityX=-1
		falling=false
		fallinghard=false
		wasonfloor=false
		wasinair=true
		fall_timer.start()
		lockdirection=false
	else:
		lockdirection=false
		allowaircontrol=true
	state=Idle
	immobilize_timer.stop()
	print("stopped")
	pass # Replace with function body.
