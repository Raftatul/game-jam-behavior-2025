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
	var vel: Vector2 = (player.dash_distance * player.las_valid_input) / player.dash_duration
	player.apply_root_motion(Vector3(vel.x, 0.0, vel.y if use_depth else 0.0), player.dash_duration)
