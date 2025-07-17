extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	$Cover/AP.play("Fade_In")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_ap_animation_finished(Fade_In):
	get_tree().change_scene_to_file("res://Splash/Splash2.tscn")
