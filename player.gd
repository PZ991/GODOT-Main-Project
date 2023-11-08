extends CharacterBody2D

class_name Player

enum {Move, Climb}
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
var state = Move

var double_jump=1


var lefttapCount = 0
var attacktapCount = 0
var righttapCount = 0
var dashdoubleTapTime = 1
var dashing = false
var attacking =false
var combodoubleTapTime = 1

func _physics_process(delta):
	
	if Input.is_action_just_pressed("ui_left")  :  # Change "ui_accept" to the action you want to use
		lefttapCount += 1
		if lefttapCount == 1:
			dashdoubleTapTime =1
		elif lefttapCount == 2 and dashdoubleTapTime > 0:
			dashing=true
			lefttapCount = 0
		elif lefttapCount > 2 or dashdoubleTapTime <= 0:
			lefttapCount = 0
	else:
		dashdoubleTapTime = max(0, dashdoubleTapTime - delta)
		
	if Input.is_action_just_pressed("ui_right") :  # Change "ui_accept" to the action you want to use
		righttapCount += 1
		if righttapCount == 1:
			dashdoubleTapTime = 1
		elif righttapCount == 2 and dashdoubleTapTime > 0:
			dashing=true
			righttapCount = 0
		elif righttapCount > 2 or dashdoubleTapTime <= 0:
			righttapCount = 0
	else:
		
		dashdoubleTapTime = max(0, dashdoubleTapTime - delta)
	
	if Input.is_mouse_button_pressed(0) :  # Change "ui_accept" to the action you want to use
		attacktapCount += 1
		if attacktapCount == 1:
			combodoubleTapTime = 0.5
		elif attacktapCount == 2 and combodoubleTapTime > 0:
			attacking=true
			attacktapCount = 0
		elif attacktapCount > 2 or combodoubleTapTime <= 0:
			attacktapCount = 0
	else:
		
		combodoubleTapTime = max(0, combodoubleTapTime - delta)
		
	
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input = Vector2.ZERO
	input.x = Input.get_axis("ui_left", "ui_right")
	input.y = Input.get_axis("ui_up", "ui_down")
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
	if is_onladder() and Input.is_action_pressed("ui_up"):
		state=Climb
	# Add the gravity.
	if not is_on_floor():
		$AnimatedSprite2D.animation="Jump"
		velocity.y += gravity * delta

	# Handle Jump.
	if is_on_floor() or coyotejump:
		double_jump=1
		if Input.is_action_just_pressed("ui_up") or buffered_jump:
			SoundPlayer.playsound(SoundPlayer.Jump)
			velocity.y = JUMP_VELOCITY
			buffered_jump=false
	else:
		if Input.is_action_just_pressed("ui_up") and double_jump>0:
			SoundPlayer.playsound(SoundPlayer.Jump)
			velocity.y = JUMP_VELOCITY
			double_jump-=1
		if Input.is_action_just_pressed("ui_up"):
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
