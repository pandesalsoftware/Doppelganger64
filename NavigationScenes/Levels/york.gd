extends Camera3D


@onready var York = $".."
@onready var York_AP = $"../York/AnimationPlayer"
@onready var York_Camera = $"."

@onready var Cooper = $"../../Cooper"


@onready var CE_Timer = $CutsceneEndTimer

func _ready():
	York_AP.play("Idle")


func _talking_begin(): 
	#York Camera is Active!
	York_AP.play("Speech")
	York_Camera.current = true
	#York Cutscene Started!
	$CutsceneEndTimer.start()


func _on_cutscene_end_timer_timeout():
	#Coop Camera is Active! 
	Cooper._switch_back_cam()
