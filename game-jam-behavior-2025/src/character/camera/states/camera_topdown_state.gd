extends CameraState


func check_relevance() -> StringName:
	if camera.request_switch:
		return &"2D"
	return ""


func enter(machine: FiniteStateMachine) -> void:
	camera.switch_to_topdown()
