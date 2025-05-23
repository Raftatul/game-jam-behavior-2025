extends PlayerState


func check_relevance() -> StringName:
	if player.is_on_floor():
		if player.input_direction.x == 0.0:
			return &"Idle"
		else:
			return &"Walk"
	elif player.request_dash:
		return &"Dash"
	return ""


func enter(_machine: FiniteStateMachine) -> void:
	player.apply_gravity = true


func exit(_machine: FiniteStateMachine) -> void:
	player.jump_land.play()
