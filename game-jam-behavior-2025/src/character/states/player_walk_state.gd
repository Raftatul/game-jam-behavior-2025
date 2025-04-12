class_name PlayerWalkState extends PlayerState


var jump_buffered: bool = false


func check_relevance() -> StringName:
	if player.input_direction.x == 0.0 and not player.root_motion_tween.is_running():
		return &"Idle"
	elif jump_buffered and not player.root_motion_tween.is_running():
		return &"Jump"
	elif player.request_dash:
		return &"Dash"
	return ""


func enter(machine: FiniteStateMachine) -> void:
	jump_buffered = false
	player.apply_gravity = true
	
	if not (player.root_motion_tween and player.root_motion_tween.is_running()):
		_move_character()


func update(machine: FiniteStateMachine, delta: float) -> void:
	if player.request_jump:
		jump_buffered = true


func _move_character() -> void:
	if player.input_direction.x == 0.0 or jump_buffered or player.finite_state_machine.current_state_name == &"Death":
		return
	
	var vel: Vector3 = Vector3.RIGHT * (player.GRID_SIZE / player.move_duration) * player.input_direction.x
	
	player.anime_state_machine.travel(player.run_animation)
	player.apply_root_motion(vel, player.move_duration)
	player.root_motion_tween.tween_callback(_move_character)
