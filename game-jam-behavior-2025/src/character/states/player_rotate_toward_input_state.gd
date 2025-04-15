extends PlayerState

@export var target_node: Node3D
@export var rotation_duration: float = 0.25

var tween: Tween

var force_walk: bool = false


func check_relevance() -> StringName:
	if tween and tween.is_running():
		return ""

	return &"Walk" if player.input_direction.length() != 0.0 or force_walk else &"Idle"


func enter(_machine: FiniteStateMachine) -> void:
	force_walk = false

	if not target_node:
		printerr("Rotate Toward Input - Target node is null")
		return

	var current_ang: float = target_node.rotation.y
	var target_ang: float = atan2(player.last_valid_input.x, player.last_valid_input.y)
	var dot_product: float = player.character_mesh.global_basis.z.dot(
		player.get_last_valid_input_direction()
	)

	if dot_product > 0.5:
		force_walk = true
		return

	tween = create_tween()

	tween.tween_method(
		rotate_target_node.bind(current_ang, target_ang), 0.0, 1.0, rotation_duration
	)


func rotate_target_node(alpha: float, start_ang: float, target_ang: float) -> void:
	target_node.rotation.y = lerp_angle(start_ang, target_ang, alpha)
