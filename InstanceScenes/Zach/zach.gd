extends CharacterBody3D

@onready var NavAgent = $NavigationAgent3D
@onready var ZS_AP = $ZachSkin/AnimationPlayer
@onready var ZS : Node3D =  %ZachSkin

@export var move_speed = 6.5

func _physics_process(delta):
	var current_location = global_transform.origin
	var next_location = NavAgent.get_next_path_position()
	var new_velocity = (next_location - current_location).normalized() * move_speed
	
	velocity = velocity.move_toward(new_velocity, .25)
	move_and_slide()
	ZS.look_at(next_location)
	ZS.rotate_object_local(Vector3.UP, PI)
	ZS_AP.play("Walk")
	

func _update_target_location(target_location):
	NavAgent.set_target_position(target_location)
