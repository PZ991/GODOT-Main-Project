extends CharacterBody2D

class_name Player

enum {Move, Climb,Freeze}
#Basics
@export var SPEED = 200.0
@export var JUMP_VELOCITY = -200.0
@export var climbspeed=50
@export  var playerdata: Player_Movement_Data #Resource
var buffered_jump=false
var coyotejump=false
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

@onready var laddercheck= $Laddercheck
@onready var jumpbuffer = $JumpBuffer
@onready var coyotejumpTimer=$CoyoteJumpTimer
@onready var remoteTranforrm = $RemoteTransform2D
#var test2= preload("res://Powers/Earth/Wall/small_rock_wall.tscn")
var state = Move

var double_jump=1


var lefttapCount = 0
var attacktapCount = 0
var righttapCount = 0
var leftdashdoubleTapTime = 1
var rightdashdoubleTapTime = 1
var dashing = false

@export var InstanceCheck:PackedScene

func _physics_process(delta):
	
	if(Input.is_action_just_pressed("Skill E")):
		state=Freeze
		$AnimatedSprite2D.play("Ground Slam 1")
		
	
	if($AnimatedSprite2D.animation=="Ground Slam 1"and $AnimatedSprite2D.animation_finished and $AnimatedSprite2D.frame==2):
		var instance = InstanceCheck.instantiate()
		#var n= test2.instantiate()
		#get_parent().add_child(n)
		var world = get_tree().current_scene
		world.add_child(instance)
		#get_parent().add_child(n)
		instance.global_position=global_position
		if(get_global_mouse_position().x> position.x):
			instance.direction=Vector2.RIGHT*5
		if(get_global_mouse_position().x< position.x):
			instance.direction=Vector2.LEFT*5
		
		state=Move
	
	if Input.is_action_just_pressed("Move Left")  :  # Change "ui_accept" to the action you want to use
		lefttapCount += 1
		if lefttapCount == 1:
			leftdashdoubleTapTime =1
		elif leftdashdoubleTapTime == 2 and leftdashdoubleTapTime > 0:
			dashing=true
			lefttapCount = 0
		elif leftdashdoubleTapTime > 2 or leftdashdoubleTapTime <= 0:
			lefttapCount = 0
	else:
		leftdashdoubleTapTime = max(0, leftdashdoubleTapTime - delta)
		
	if Input.is_action_just_pressed("Move Right") :  # Change "ui_accept" to the action you want to use
		righttapCount += 1
		if righttapCount == 1:
			rightdashdoubleTapTime = 1
		elif rightdashdoubleTapTime == 2 and rightdashdoubleTapTime > 0:
			dashing=true
			righttapCount = 0
		elif rightdashdoubleTapTime > 2 or rightdashdoubleTapTime <= 0:
			righttapCount = 0
	else:
		
		rightdashdoubleTapTime = max(0, rightdashdoubleTapTime - delta)
	
	
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input = Vector2.ZERO
	input.x = Input.get_axis("Move Left", "Move Right")
	input.y = Input.get_axis("Move Up", "Move Down")
	if not dashing:
		match state:
			Move: movestate(delta,input.x)
			Climb:climbstate(input)
	else:
		print("test")
		handle_double_tap(input)
	
	
	if get_global_mouse_position().x- position.x<0:
		$AnimatedSprite2D.flip_h=false
	if get_global_mouse_position().x- position.x>0:
		$AnimatedSprite2D.flip_h=true
#	if state == Move: movestate(delta,direction)
#	elif state==Climb:climbstate(directionclimb)
	

	move_and_slide()

func PlayerDeath():
	SoundPlayer.playsound(SoundPlayer.Hurt)
	queue_free()
	Events.emit_signal("playerdied")
#	get_tree().reload_current_scene()
	
	
func movestate(delta, direction):
	
		
	if Input.is_key_pressed(KEY_CTRL):
		crouch()
		return
	
	gravity=980
	if is_onladder() and Input.is_action_pressed("Move Up"):
		state=Climb
	# Add the gravity.
	if not is_on_floor():
		$AnimatedSprite2D.animation="Jump"
		velocity.y += gravity * delta

	# Handle Jump.
	if is_on_floor() or coyotejump:
		double_jump=1
		if Input.is_action_just_pressed("Jump") or buffered_jump:
			SoundPlayer.playsound(SoundPlayer.Jump)
			velocity.y = JUMP_VELOCITY
			buffered_jump=false
	else:
		if Input.is_action_just_pressed("Jump") and double_jump>0:
			SoundPlayer.playsound(SoundPlayer.Jump)
			velocity.y = JUMP_VELOCITY
			double_jump-=1
		if Input.is_action_just_pressed("Jump"):
			SoundPlayer.playsound(SoundPlayer.Jump)
			buffered_jump=true;
			jumpbuffer.start()
	if direction:
		if Input.is_key_pressed(KEY_SHIFT):
			$AnimatedSprite2D.animation="Run"
			velocity.x = direction * SPEED*2
		else:
			if (get_global_mouse_position().x- position.x>0 and $AnimatedSprite2D.flip_h and direction>0) or(get_global_mouse_position().x- position.x<0 and not $AnimatedSprite2D.flip_h and direction<0) :
				$AnimatedSprite2D.animation="Jog"
				velocity.x = direction * SPEED
			if (get_global_mouse_position().x- position.x>0 and $AnimatedSprite2D.flip_h and direction<0) or(get_global_mouse_position().x- position.x<0 and not $AnimatedSprite2D.flip_h and direction>0) :
				$AnimatedSprite2D.animation="Jog_Backward"
				velocity.x = direction * SPEED/2
		
	else:
		$AnimatedSprite2D.animation="Idle"
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	var wasinair=not is_on_floor()
	var wasonfloor = is_on_floor()
	var justlanded =is_on_floor() and wasinair
	if justlanded:
		$AnimatedSprite2D.animation="Run"
		$AnimatedSprite2D.frame=1;
	var justleftground = not is_on_floor() and wasonfloor
	if justleftground and velocity.y>=0:
		coyotejump=true
		coyotejumpTimer.start()
	pass
	
func climbstate(input):
	if input.y!=0 : $AnimatedSprite2D.animation="Run"
	else: $AnimatedSprite2D.animation="Idle"
	velocity=input*climbspeed
	gravity=0

	if not is_onladder(): state = Move
	pass

func is_onladder():
	if not laddercheck.is_colliding(): return false
	var collider = laddercheck.get_collider()
	if not collider is Ladder: return false
	return true


func _on_jump_buffer_timeout():
	buffered_jump=false
	pass # Replace with function body.


func _on_coyote_jump_timer_timeout():
	coyotejump=false
	pass # Replace with function body.

func connectcam(cam):
	var camerapath= cam.get_path()
	remoteTranforrm.remote_path=camerapath

func crouch():
	$AnimatedSprite2D.animation="Crouch"

func handle_double_tap(direction):
	if (get_global_mouse_position().x- position.x>0 and $AnimatedSprite2D.flip_h and direction.x>0) or(get_global_mouse_position().x- position.x<0 and not $AnimatedSprite2D.flip_h and direction.x<0) :
		$AnimatedSprite2D.animation="Dash_Forward"
	if (get_global_mouse_position().x- position.x>0 and $AnimatedSprite2D.flip_h and direction.x<0) or(get_global_mouse_position().x- position.x<0 and not $AnimatedSprite2D.flip_h and direction.x>0) :
		$AnimatedSprite2D.animation="Dash_Backward"
	
	move_and_collide(Vector2(10*direction.x,0))
	if $AnimatedSprite2D.frame==2:
	#if $AnimatedSprite2D.animation=="Dash_Forward" or $AnimatedSprite2D.animation=="Dash_Backward":
		dashing = false
