extends Node3D

@onready var Cooper = $Characters/Cooper



#Weird error but not game breaking...If switched to alternate script The Doppelganger doesn't go to Cooper as intended. 
func _physics_process(delta):
	get_tree().call_group("Enemies", "_update_target_location", Cooper.global_transform.origin)
