extends Node3D


@export var override_pos: bool = false


func _ready() -> void:
	if override_pos:
		CheckpointManager.respawn_point = get_node("Character").global_position
