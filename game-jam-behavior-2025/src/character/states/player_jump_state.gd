extends PlayerState


func check_relevance() -> StringName:
	return &"Fall"


func enter(machine: FiniteStateMachine) -> void:
	player.anime_state_machine.travel(player.fall_animation)
	player.velocity.y += player.jump_force
	player.apply_gravity = true
