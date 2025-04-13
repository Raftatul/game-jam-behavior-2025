extends Node3D


@onready var animation_player: AnimationPlayer = $Checkpoint/AnimationPlayer


func _on_area_3d_body_entered(body: Node3D) -> void:
	if body is PlayerCharacter:
		animation_player.play("enter")
		CheckpointManager.respawn_point = global_position
