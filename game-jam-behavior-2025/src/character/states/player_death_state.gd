extends PlayerState


func check_relevance() -> StringName:
	return ""


func enter(machine: FiniteStateMachine) -> void:
	player.apply_gravity = false
	player.velocity = Vector3.ZERO
	
	if player.root_motion_tween:
		player.root_motion_tween.kill()


func update(machine: FiniteStateMachine, delta: float) -> void:
	pass


func exit(machine: FiniteStateMachine) -> void:
	pass
