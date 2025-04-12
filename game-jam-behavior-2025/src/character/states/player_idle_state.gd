extends PlayerState


func check_relevance() -> StringName:
	if player.input_direction != 0.0:
		return &"Walk"
	elif player.request_jump:
		return &"Jump"
	return ""


func enter(machine: FiniteStateMachine) -> void:
	player.apply_gravity = true


func exit(machine: FiniteStateMachine) -> void:
	pass
