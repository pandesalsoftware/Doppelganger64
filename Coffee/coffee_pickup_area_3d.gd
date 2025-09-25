extends Area3D


#COFFEE REFILL

@onready var Cooper : CharacterBody3D = get_tree().get_first_node_in_group("Cooper")
@onready var  InteractPrompt = $"../InteractPrompt"

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
		print("Coffee Equipped!")
		Cooper._coffee_refill()
