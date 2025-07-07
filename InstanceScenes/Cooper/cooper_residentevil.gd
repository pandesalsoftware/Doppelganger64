extends CharacterBody3D

var move_speed = 5
var turn_speed = 100
const gravity = 98
const max_fall_speed = 30

@onready var _anim = $CooperSkin/AnimationPlayer
@onready var _Skin: Node3D = %CooperSkin
@onready var _WalkSound: AudioStreamPlayer3D = %WalkSound

var y_velo = 0 
var grounded = false 


func _ready():
	pass

func _physics_process(delta):
	#Movement Controls --------------------------------------------- 
	
	var move_dir = 0 
	var turn_dir = 0 
	
	if Input.is_action_pressed("Move_Forward"):
		move_dir += 1
	if Input.is_action_pressed("Move_Backward"):
		move_dir -= 1
	if Input.is_action_pressed("Turn_Right"):
		move_dir -= 1
	if Input.is_action_pressed("Turn_Left"):
		move_dir += 1
	
	rotation_degrees.y += turn_dir * turn_speed * delta
	var move_vec = global_transform.basis.z *move_speed * move_dir
	move_vec.y  = y_velo
	move_and_slide()



func _input(event):
	#Misc. Controls ---------------------------------------------
	#Input = "Left Click" to Capture Mouse Movement i.e. Control the camera.
	if event.is_action_pressed("left_click"):
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	
	#Input = "Alt" to Navigate other Windows. 
	if event.is_action_pressed("Alt"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	
	#Input = "2" to Make Cooper non-visible for Screenshots 
	if event.is_action_pressed("PhotoMode"):
		_Skin.visible = false
	
	#Scene Navigation -----------------------------
	#Input = "R"
	if Input.is_action_just_pressed("Restart"):
		get_tree().reload_current_scene()
	
	#Input = "Esc"
	if Input.is_action_just_pressed("Exit"):
		get_tree().quit()
	
	#Input = "3"
	if Input.is_action_just_pressed("DeathTest"):
		#Insert Death Animations & Processes here!
		pass
		
#Movement & Animations --------------------------------------------------
	#Variables
	var ground_speed := velocity.length()
	var AP = $CooperSkin/AnimationPlayer
	
		
	if Input.is_action_pressed("Run"):
		move_speed = 16
		AP.play("Run001")

	elif Input.is_action_just_released("Run"):
		move_speed = 8
		
	if ground_speed > 0.0:
		AP.play("Walk002")
		if $Timer.time_left <= 0:
			%WalkSound.play()
			$Timer.start(0.9)
	else:
		AP.play("Idle02")


#Doppelganger Collisions 
#---------------------------------------------------------
#Lose health state (Donut) ... If hit by Doppelganger
func _lose_life():
	pass

#Lost all Donuts 
func _KO():
	pass 
	print("In heavan, everything is fine...")

#Interactable Collisions
#---------------------------------------------------------
