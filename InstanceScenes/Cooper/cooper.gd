extends CharacterBody3D

@export_group("Camera")
@export_range(0.0, 1.0) var mouse_sensitivity := 0.25

@export_group("Movement")
@export var move_speed := 10.5 # Changed to float for consistency
@export var acceleration := 20.0
@export var gravity := 25.0


var _camera_input_direction := Vector2.ZERO
var _last_movement_direction := Vector3.BACK

@onready var _camera_pivot: Node3D = %CameraPivot
@onready var _camera: Camera3D = %Camera3D
@onready var _Skin: Node3D = %CooperSkin
@onready var _WalkSound: AudioStreamPlayer3D = %WalkSound
@onready var _animation_player: AnimationPlayer = %CooperSkin/AnimationPlayer # Get AnimationPlayer once
@onready var _coffeeMug: MeshInstance3D = $CooperSkin/Armature/Skeleton3D/CoffeeMug/CoffeeMug
@onready var _coffeeSpillScene: PackedScene = preload("res://Coffee/coffee_spill.tscn")

var can_run = true
var can_spill = false


func _ready():
	_coffeeMug.visible = false
	_animation_player.play("Idle02")

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
	
	if event.is_action_pressed("Spill") and can_spill:
		_animation_player.queue("Spill_Coffee")
		can_spill = false
	
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
		
	# Handle Run input for speed change and timer
	if Input.is_action_pressed("Run") and not _coffeeMug.visible:
		move_speed = 17.5
		$SprintBoostTimer.start()
	elif Input.is_action_just_released("Run"):
		move_speed = 10.5 # Speed will be reset by timer as well, but this ensures immediate change

func _unhandled_input(event: InputEvent) -> void:
	var is_camera_motion := (
		event is InputEventMouseMotion and 
		Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED
	)
	if is_camera_motion:
		_camera_input_direction = event.screen_relative * mouse_sensitivity

func _physics_process(delta: float) -> void:
	
	# Camera Controls --------------------------------------------------
	_camera_pivot.rotation.y -= _camera_input_direction.x * delta
	_camera_input_direction = Vector2.ZERO
	
	# Gravity Handling ------------------------------------------------------
	if is_on_floor() == false:
		velocity.y -= gravity * delta
	else : 
		velocity.y = -0.5
	
	# Movement Controls --------------------------------------------------
	var raw_input := Input.get_vector("Forward","Backward", "Left", "Right")
	var forward := _camera.global_basis.x
	var right := _camera.global_basis.z
	
	var move_direction := forward * raw_input.y + right * raw_input.x
	move_direction.y = 0.0
	move_direction = move_direction.normalized()
	
	var target_velocity_horizontal = move_direction * move_speed
	
	velocity.x = lerp(velocity.x, target_velocity_horizontal.x, acceleration * delta)
	velocity.z = lerp(velocity.z, target_velocity_horizontal.z, acceleration * delta)
	
	move_and_slide()
	
	if move_direction.length() > 0.1:
		_last_movement_direction = move_direction
	var target_angle := Vector3.BACK.signed_angle_to(_last_movement_direction, Vector3.UP)
	_Skin.global_rotation.y = target_angle

	# Animation Logic (Moved here for consistent updates) --------------------
	if not can_spill and _coffeeMug.visible:
		return
	
	var ground_speed := velocity.length()
	
	if _coffeeMug.visible:
		if ground_speed > 0.1:
			_animation_player.play("Walk_Coffee")
		else : 
			_animation_player.play("Idle_Coffee")
		
	else : 
		if Input.is_action_pressed("Run") and ground_speed > 0.1:
			_animation_player.play("Run001")
		elif ground_speed > 0.1:
			_animation_player.play("Walk002")
			if $Timer.time_left <= 0: 
				_WalkSound.play()
				$Timer.start(0.9)
		else : 
			_animation_player.play("Idle02")

func _on_animation_player_animation_finished(anim_name):
	if anim_name == "Spill_Coffee":
		var coffeeSpill_Inst = _coffeeSpillScene.instantiate()
		get_tree().root.add_child(coffeeSpill_Inst)
		coffeeSpill_Inst.global_position = self.global_position
		can_spill = true
		_coffeeMug.visible = false

func _coffee_refill():
	_coffeeMug.visible = true
	can_spill = true

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
	move_speed = 10.5 # Reset move speed after sprint boost
	can_run = false # This variable is not currently used, but kept for context
	$SprintCooldownTimer.start() # Start cooldown timer


func _on_sprint_cooldown_timer_timeout():
	can_run = true # Allow running again after cooldown


#Camera Switching 
#---------------------------------------------------------
func _switch_back_cam():
	_camera.make_current()
