extends Area3D


#START STATUE


@onready var  InteractPrompt = $"../InteractPrompt"
@onready var AniObject = $"../../EASTstatue"
@onready var AniObj_AP = $"../../EASTstatue/AnimationPlayer"

var in_radius = false 


func _enter_radius(body):
	if body.name == "Cooper":
		in_radius = true 
	if in_radius:
		print("Cooper entered Statue radius!")
		InteractPrompt.visible = true 

func _exit_radius(body):
	if body.name == "Cooper":
		in_radius = false
		print("Cooper exited Statue radius!")
		InteractPrompt.visible = false


func _physics_process(delta):
	if InteractPrompt.visible && Input.is_action_just_pressed("Interact"): 
		print("Dropping Obstacle!")
		AniObj_AP.play("Fall_Over")
