extends Node3D

@onready var C_AP = $Camera3D/AnimationPlayer


func _on_animation_player_animation_finished(Move):
	$Camera3D/AnimationPlayer.play("Sway")
