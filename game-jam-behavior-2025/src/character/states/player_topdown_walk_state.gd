extends PlayerState


func check_relevance() -> StringName:
	if (
		player.input_direction.x == 0.0
		and player.root_motion_tween
		and not player.root_motion_tween.is_running()
	):
		return &"Idle"
	elif player.request_dash:
		return &"Dash"
	return ""


func enter(_machine: FiniteStateMachine) -> void:
	player.step_sounds_anim.play("footsteps")
	player.apply_gravity = true
	player.anime_state_machine.travel(player.run_animation)

	if not (player.root_motion_tween and player.root_motion_tween.is_running()):
		_move_character(true)


func exit(_machine: FiniteStateMachine) -> void:
	player.step_sounds_anim.stop()


func _move_character(forcer_move: bool = false) -> void:
	if (
		not forcer_move
		and (
			player.input_direction.length() == 0.0
			or player.finite_state_machine.current_state_name == &"Death"
		)
	):
		return

	var vel: Vector2 = player.last_valid_input * (player.GRID_SIZE / player.move_duration)

	player.apply_root_motion(Vector3(vel.x, 0.0, vel.y), player.move_duration)
	player.root_motion_tween.tween_callback(_move_character)
