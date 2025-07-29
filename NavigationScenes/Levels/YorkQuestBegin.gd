extends Area3D


var in_radius = false 


func _enter_radius(body):
	if body.name == "Cooper":
		in_radius = true 
	if in_radius:
		print("Cooper entered York radius!")
		$"../InteractPrompt".visible = true 

func _exit_radius(body):
	if body.name == "Cooper":
		in_radius = false
		print("Cooper exited York radius!")
		$"../InteractPrompt".visible = false


func _physics_process(delta):
	if $"../InteractPrompt".visible && Input.is_action_just_pressed("Interact"): 
		print("Starting York Quest")
		$"../../TalkingCamera"._talking_begin()
