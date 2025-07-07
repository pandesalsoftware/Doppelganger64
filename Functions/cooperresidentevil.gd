extends CharacterBody3D

@export_group("Camera")
@export_range(0.0, 1.0) var mouse_sensitivity := 0.25

@export_group("Movement")
@export var move_speed := 8
@export var acceleration := 20.0


var _camera_input_direction := Vector2.ZERO
var _last_movement_direction := Vector3.BACK


@onready var _camera: Camera3D = %Camera3D
@onready var _Skin: Node3D = %CooperSkin
@onready var _WalkSound: AudioStreamPlayer3D = %WalkSound


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
	

func _unhandled_input(event: InputEvent) -> void:
	var is_camera_motion :=(
		event is InputEventMouseMotion and 
		Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED
	)
	if is_camera_motion:
		_camera_input_direction = event.screen_relative * mouse_sensitivity

func _physics_process(delta: float) -> void:
	
	
	
#Camera Controls 
	_camera_pivot.rotation.x += _camera_input_direction.y * delta
	_camera_pivot.rotation.x = clamp(_camera_pivot.rotation.x, -PI / 6.0, PI / 3.0)
	_camera_pivot.rotation.y -= _camera_input_direction.x * delta
	
	_camera_input_direction = Vector2.ZERO
	
	#Movement Controls #--------------------------------------------------
	var raw_input := Input.get_vector("Forward","Backward", "Left", "Right")
	var forward := _camera.global_basis.x
	var right := _camera.global_basis.z
	
	var move_direction := forward * raw_input.y + right * raw_input.x
	move_direction.y = 0.0
	move_direction = move_direction.normalized()
	
	velocity = velocity.move_toward(move_direction * move_speed, acceleration * delta)
	move_and_slide()
	
	if move_direction.length() > 0.2:
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
