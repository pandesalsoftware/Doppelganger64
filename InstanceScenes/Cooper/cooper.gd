extends CharacterBody3D

enum {IDLE, RUN, WALK}
var curAnim = IDLE

@export_group("Camera")
@export_range(0.0, 1.0) var mouse_sensitivity := 0.25

@export_group("Movement")
@export var move_speed := 8
@export var acceleration := 20.0
@export var gravity := 25.0


var _camera_input_direction := Vector2.ZERO
var _last_movement_direction := Vector3.BACK

@onready var _camera_pivot: Node3D = %CameraPivot
@onready var _camera: Camera3D = %Camera3D
@onready var _Skin: Node3D = %CooperSkin
@onready var _WalkSound: AudioStreamPlayer3D = %WalkSound
@onready var AP: AnimationPlayer = $CooperSkin/AnimationPlayer

#Animation Variables 
@onready var AT: AnimationTree = $AnimationTree
@export var blendSpeed = 15

#Animation Blend Data
var Run_V = 0 
var Walk_V = 0 

var can_run = true


func _ready():
	pass

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
		$SprintBoostTimer.start()
		curAnim = RUN

	elif Input.is_action_just_released("Run"):
		move_speed = 8
		
	if ground_speed > 0.1:
		curAnim = WALK
		if $Timer.time_left <= 0:
			%WalkSound.play()
			$Timer.start(0.9)
	else:
		curAnim = IDLE
	

func _unhandled_input(event: InputEvent) -> void:
	var is_camera_motion :=(
		event is InputEventMouseMotion and 
		Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED
	)
	if is_camera_motion:
		_camera_input_direction = event.screen_relative * mouse_sensitivity

func _physics_process(delta: float) -> void:
	
	match curAnim:
		IDLE:
			Run_V = lerpf(Run_V, 0, blendSpeed * delta)
			Walk_V = lerpf(Walk_V, 0, blendSpeed * delta)
		RUN:
			Run_V = lerpf(Run_V, 1, blendSpeed * delta)
			Walk_V = lerpf(Walk_V, 0, blendSpeed * delta)
	
	
#Camera Controls 
	_camera_pivot.rotation.y -= _camera_input_direction.x * delta
	
	_camera_input_direction = Vector2.ZERO
	
	#Gravity Handling ------------------------------------------------------
	if  is_on_floor() == false:
		velocity.y -= gravity * delta
	else : 
		velocity.y = -0.5
	
	#Movement Controls #--------------------------------------------------
	var raw_input := Input.get_vector("Forward","Backward", "Left", "Right")
	var forward := _camera.global_basis.x
	var right := _camera.global_basis.z
	
	var move_direction := forward * raw_input.y + right * raw_input.x
	move_direction.y = 0.0
	move_direction = move_direction.normalized()
	
	var target_velocity_horizontal = move_direction * move_speed
	
	velocity.x = lerp(velocity.x, target_velocity_horizontal.x, acceleration *delta)
	velocity.z = lerp(velocity.z, target_velocity_horizontal.z, acceleration * delta)
	
	move_and_slide()
	
	if move_direction.length() > 0.1:
		_last_movement_direction = move_direction
	var target_angle := Vector3.BACK.signed_angle_to(_last_movement_direction, Vector3.UP)
	_Skin.global_rotation.y = target_angle

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


func _on_sprint_boost_timer_timeout():
	move_speed = 8
	var can_run = false 
	$SprintCooldownTimer


func _on_sprint_cooldown_timer_timeout():
	pass


#Camera Switching 
#---------------------------------------------------------
func _switch_back_cam():
	_camera.make_current()


#Animation Handling 
#---------------------------------------------------------



func _AT_update():
	AT["parameters/RunBlend/blend_amount"] = Run_V
	AT["parameters/WalkBlend/blend_amount"] = Walk_V
