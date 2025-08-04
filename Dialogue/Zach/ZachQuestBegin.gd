extends Area3D

var D_START = preload("res://Dialogue/Zach/zachSTARTcontrol.tscn")

@onready var Zach = $"../.."

var in_radius = false 


func _enter_radius(body):
	if body.name == "Cooper":
		in_radius = true 
	if in_radius:
		print("Cooper entered Zach radius!")
		$"../InteractPrompt".visible = true 

func _exit_radius(body):
	if body.name == "Cooper":
		in_radius = false
		print("Cooper exited Zach radius!")
		$"../InteractPrompt".visible = false


func _physics_process(delta):
	if $"../InteractPrompt".visible && Input.is_action_just_pressed("Interact"): 
		print("Starting Zach Quest")
		$"../InteractPrompt".visible = false
		#Instancing Dialogue scene 
		print("Playing Zach START Dialogue.")
		var dS = D_START.instantiate()
		add_child(dS)
		Zach._talking()
