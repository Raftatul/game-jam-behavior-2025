extends PlayerState


func check_relevance() -> StringName:
	if player.is_on_floor():
		if player.input_direction == 0.0:
			return &"Idle"
		else:
			return &"Walk"
	return ""


func enter(machine: FiniteStateMachine) -> void:
	player.apply_gravity = true
