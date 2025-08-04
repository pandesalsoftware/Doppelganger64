extends CharacterBody3D

@onready var NavAgent = $NavigationAgent3D
@onready var DS_AP = $DoppelgangerSkin/AnimationPlayer
@onready var DS : Node3D =  %DoppelgangerSkin

@export var move_speed = 4

func _physics_process(delta):
	var current_location = global_transform.origin
	var next_location = NavAgent.get_next_path_position()
	var new_velocity = (next_location - current_location).normalized() * move_speed
	
	velocity = velocity.move_toward(new_velocity, .25)
	move_and_slide()
	DS.look_at(next_location)
	DS.rotate_object_local(Vector3.UP, PI)
	DS_AP.play("Walk002")
	

func _update_target_location(target_location):
	NavAgent.set_target_position(target_location)


func _on_navigation_agent_3d_target_reached():
	print("Cooper reached!")
	move_speed = 0
