extends RigidBody3D



func _on_area_3d_body_entered(body):
	if body.is_in_group("Floor"):
		self.freeze_mode = RigidBody3D.FREEZE_MODE_STATIC
		$AnimationPlayer.play("Scale")


	if body.is_in_group("Enemies"):
		body._slip()
		$Timer.start()


func _on_timer_timeout():
	queue_free()
