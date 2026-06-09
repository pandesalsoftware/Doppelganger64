extends CharacterBody3D

@onready var Cooper = get_tree().get_nodes_in_group("Cooper")

@onready var NavAgent = $NavigationAgent3D
@onready var DS_AP = $DoppelgangerSkin/AnimationPlayer
@onready var DS : Node3D =  %DoppelgangerSkin

@onready var QF_T = $QF_Timer
@onready var Idle_T  = $IdleTimer
@onready var Stun_T = $StunTimer

@export var move_speed := 30
@export var accel := 6
@export var gravity := 25.0

func _physics_process(delta):
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
	DS_AP.play("Run001")
	

func _update_target_location(target_location):
	NavAgent.set_target_position(target_location)


func _slip():
	move_speed = 0 
	DS_AP.play("WALK_Slip")
	Stun_T.start()


func _on_stun_timer_timeout():
	DS_AP.play("GetUp")


func _on_animation_player_animation_finished(anim_name):
	if anim_name == "GetUp":
		move_speed = 10


func _on_attack_shape_child_entered_tree(Cooper) :
	print("Cooper reached!")
	DS_AP.play("Grab")
	move_speed = 0
	#1 in 3 chance that he will really grab you? 


func _on_chase_shape_child_entered_tree(node: Node) -> void:
	QF_T.start()


func _on_qf_timer_timeout() -> void:
	self.queue_free()
