extends Camera3D

@onready var York = $".."
@onready var York_AP = $"../York/AnimationPlayer"
@onready var York_Camera = $"."

func _ready():
	York_AP.play("Idle")


func _talking_begin(): 
	York_AP.play("Speech")
	York_Camera.current = true
	$Control.visible = true 
	$"../YorkQuestOPEN/InteractPrompt".visible = false
