class_name PlayerWalkState extends PlayerState


func check_relevance() -> StringName:
	if player.input_direction == 0.0 and not player.root_motion_tween.is_running():
		return &"Idle"
	elif player.request_jump:
		return &"Jump"
	return ""


func enter(machine: FiniteStateMachine) -> void:
	player.apply_gravity = true
	
	if not (player.root_motion_tween and player.root_motion_tween.is_running()):
		player.anime_state_machine.travel(player.run_animation)
		_move_character()


func _move_character() -> void:
	if player.input_direction == 0.0 or player.finite_state_machine.current_state_name == &"Death":
		return
	
	var x_destination: float = player.global_position.x + player.input_direction * player.GRID_SIZE
	
	player.apply_horizontal_motion(x_destination, player.move_duration)
	player.root_motion_tween.tween_callback(_move_character)
