extends Camera3D


@onready var York = $".."
@onready var York_AP = $"../York/AnimationPlayer"
@onready var York_Camera = $"."

@onready var Cooper = get_tree().get_first_node_in_group("Cooper")



func _ready():
	York_AP.play("Idle")


func _talking_begin(): 
	#York Camera is Active!
	York_AP.play("Speech")
	#York Cutscene Started!
