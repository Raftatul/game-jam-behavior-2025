extends CameraState


func check_relevance() -> StringName:
	if camera.request_switch:
		return &"TopDown"
	return ""


func enter(_machine: FiniteStateMachine) -> void:
	camera.switch_to_2d()
