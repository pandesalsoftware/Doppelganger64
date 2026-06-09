extends Node3D

@onready var C_AP = $Camera3D/AnimationPlayer
@onready var T_AP = $"2D/Tribute/AnimationPlayer"

var gameStart = false 

func _on_animation_player_animation_finished(anim_name):
	if !gameStart and anim_name == "Move":
		$Camera3D/AnimationPlayer.play("Sway")
		
	if gameStart and anim_name == "Fade_2":
		get_tree().change_scene_to_file("res://NavigationScenes/Levels/starting_room.tscn")


func _on_play_pressed() -> void:
	gameStart = true 
	C_AP.play("Move_2")
	T_AP.play("Fade_2")
