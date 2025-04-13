extends PlayerState


@export var use_depth: bool = false


func check_relevance() -> StringName:
	if not player.root_motion_tween.is_running():
		if player.input_direction.length() != 0.0:
			return &"Walk"
		else:
			return &"Idle"
	return ""


func enter(machine: FiniteStateMachine) -> void:
	player.dash.play()
	player.anime_state_machine.travel(player.dash_animation)
	var vel: Vector2 = (player.dash_distance * player.last_valid_input) / player.dash_duration
	player.apply_root_motion(Vector3(vel.x, 0.0, vel.y if use_depth else 0.0), player.dash_duration)
