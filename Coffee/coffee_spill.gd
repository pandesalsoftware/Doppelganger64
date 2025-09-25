extends Node3D


var Enemies = get_tree().get_nodes_in_group("Enemies")



func _on_area_3d_body_entered(body):
	Enemies._slip()
