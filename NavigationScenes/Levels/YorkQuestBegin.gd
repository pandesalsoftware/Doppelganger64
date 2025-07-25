extends Area3D


var in_radius = false 


func _enter_radius(body):
	if body.name == "Cooper":
		in_radius = true 
	if in_radius:
		print("In radius!")

func _exit_radius(body):
	if body.name == "Cooper":
		in_radius = false

func _physics_process(_delta: float)  ->  void:
	if in_radius && get_parent().current != true:
		get_parent().current = true
