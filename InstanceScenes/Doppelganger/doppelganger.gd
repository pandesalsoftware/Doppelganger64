extends CharacterBody3D

@onready var NavAgent = $NavigationAgent3D
@onready var DS_AP = $DoppelgangerSkin/AnimationPlayer
@onready var DS : Node3D =  %DoppelgangerSkin
@onready var IT = $IdleTimer

@export var move_speed := 10
@export var accel := 6
@export var gravity := 25.0

#Doppelganger States --------------------------------------------
enum States {
 IDLE,
 DOWN,
 CHASE,
 GRAB,
 SLIP,
 GET_UP,
 }

var state = States.IDLE

#--------------------------------------------
func _change_state(newState):
	state = newState


func _physics_process(delta):
	
	match state:
		States.IDLE:
			_idle()
		States.DOWN:
			_down()	
		States.CHASE:
			_chase()
		States.GRAB:
			_grab()
		States.SLIP:
			_slip()
		States.GET_UP:
			_get_up()
			
	
	#Gravity Handling --------------------------------------------
	if is_on_floor() == false:
		velocity.y -= gravity * delta 
	else: 
		velocity.y = -0.5
	
	
	#Navigation and Movement --------------------------------------------
	var current_location = global_transform.origin
	var next_location = NavAgent.get_next_path_position()
	
	
	var new_velocity = (next_location - current_location).normalized() * move_speed
	
	velocity.x = lerp(velocity.x, new_velocity.x, accel * delta)
	velocity.z = lerp(velocity.z, new_velocity.z, accel * delta)
	
	move_and_slide()
	
	DS.look_at(next_location)
	DS.rotate_object_local(Vector3.UP, PI)
	DS_AP.play("Walk002")
	


func _update_target_location(target_location):
	NavAgent.set_target_position(target_location)


func _on_navigation_agent_3d_target_reached():
	print("Cooper reached!")
	DS_AP.play("Grab")
	move_speed = 0
	#1 in 3 chance that he will really grab you? 


func _idle():
	pass

func _down():
	pass

func _chase():
	pass


func _grab():
	pass


func _get_up():
	pass


func _slip():
	move_speed = 0 
	DS_AP.play("WALK_Slip")
	$StunTimer.start()


func _on_stun_timer_timeout():
	DS_AP.play("GetUp")


func _on_animation_player_animation_finished(anim_name):
	if anim_name == "GetUp":
		move_speed = 10
