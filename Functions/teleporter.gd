extends CharacterBody3D


@onready var Cooper : CharacterBody3D = get_tree().get_first_node_in_group("Cooper")


func _on_area_3d_area_entered(area):
	if area.is_in_group("Cooper"):
		print("Would you like to leave?")
		_change_scene()

func _change_scene():
	$UI.visible = true
