extends Node3D


func _ready() -> void:
	CheckpointManager.respawn_point = get_node("Character").global_position
