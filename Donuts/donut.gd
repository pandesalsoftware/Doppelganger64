extends Area3D

@onready var donut = $"../.."
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
	if in_radius:
		print("Donut Eaten!")
		donut.queue_free()
		pass
