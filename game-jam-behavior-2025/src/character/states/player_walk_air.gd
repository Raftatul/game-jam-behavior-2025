extends PlayerWalkState


func check_relevance() -> StringName:
	if player.is_on_floor():
		return &"Idle"
	elif player.input_direction == 0.0 and not player.root_motion_tween.is_running():
		return &"Fall"
	return ""
