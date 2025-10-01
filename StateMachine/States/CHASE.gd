extends State


class_name CHASE


func _physics_process(delta):
	var chara = state_machine.get_parent()
	
	var move_speed = chara.move_speed
	
	if move_speed == 0:
		state_machine._change_state("IDLE")
		return

	#Navigation and Movement --------------------------------------------
	var current_location = chara.global_transform.origin
	var next_location = chara.NavAgent.get_next_path_position()
	
	
	var new_velocity = (next_location - current_location).normalized() * move_speed
	
	chara.velocity.x = lerp(chara.velocity.x, new_velocity.x, chara.accel * delta)
	chara.velocity.z = lerp(chara.velocity.z, new_velocity.z, chara.accel * delta)
	
	chara.move_and_slide()
	
	chara.DS.look_at(next_location)
	chara.DS.rotate_object_local(Vector3.UP, PI)
	chara.DS_AP.play("Run001")
	

func _update_target_location(target_location):
	var chara = state_machine.get_parent()
	chara.DS.NavAgent.set_target_position(target_location)
