extends CharacterBody3D

@onready var NavAgent = $NavigationAgent3D
@onready var ZS_AP = $ZachSkin/AnimationPlayer
@onready var ZS : Node3D =  %ZachSkin


@export var move_speed = 6.5

var follow = false 

func _ready():
	ZS_AP.play("Idle")

func _physics_process(delta):
	if follow:
		move_speed = 6.5
		var current_location = global_transform.origin
		var next_location = NavAgent.get_next_path_position()
		var new_velocity = (next_location - current_location).normalized() * move_speed
	
		velocity = velocity.move_toward(new_velocity, .25)
		move_and_slide()
		ZS.look_at(next_location)
		ZS.rotate_object_local(Vector3.UP, PI)
		ZS_AP.play("Walk")
	
	else: 
		velocity = Vector3.ZERO
		ZS_AP.play("Idle")


func _update_target_location(target_location):
	if follow:
		NavAgent.set_target_position(target_location)


func _talking():
	follow = false
	ZS_AP.play("Speech")



func _start_following():
	follow = true


func _on_animation_player_animation_finished(anim_name):
	if anim_name == "Speech":
		_start_following()
