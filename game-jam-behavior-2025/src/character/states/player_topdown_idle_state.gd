extends PlayerState


func check_relevance() -> StringName:
	if player.input_direction.length() != 0.0:
		return &"Walk"
	elif player.request_dash:
		return &"Dash"
	return ""


func enter(machine: FiniteStateMachine) -> void:
	player.anime_state_machine.travel(player.idle_animation)
	player.apply_gravity = true
	player.step_sounds_anim.stop()
