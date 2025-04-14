extends Node3D


@export var trigger: Area3D
@export var lerp_speed: float = 0.1

var focused:bool = false

var target: Node3D


func _ready() -> void:
	trigger.body_entered.connect(thing)


func _physics_process(_delta: float) -> void:
	if focused:
		var direction: Vector3 = target.global_position - global_position
		var basis_target = Basis.looking_at(direction, Vector3.UP, true)

		global_basis = global_basis.slerp(basis_target, lerp_speed)


func thing(area: Node3D):
	if area is PlayerCharacter:
		focused = true
		target = get_tree().get_first_node_in_group("player")
