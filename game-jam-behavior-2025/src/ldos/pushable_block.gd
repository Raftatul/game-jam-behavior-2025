extends MoveableBody


func _on_area_3d_body_entered(body: Node3D) -> void:
	if body is PlayerCharacter:
		var direction: Vector3 = Vector3(body.last_valid_input.x, 0.0, body.last_valid_input.y)
		apply_root_motion((direction * 2.0) / body.move_duration, body.move_duration)
