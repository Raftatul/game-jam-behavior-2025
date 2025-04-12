extends PlayerState


func check_relevance() -> StringName:
	return &"Fall"


func enter(machine: FiniteStateMachine) -> void:
	player.velocity.y += player.jump_force
	player.apply_gravity = true
