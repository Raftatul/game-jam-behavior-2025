extends Node3D


@onready var animation_player: AnimationPlayer = $Checkpoint/AnimationPlayer
@onready var spawn_point_sound: AudioStreamPlayer = $SpawnPointSound

var activated:bool = false

func _on_area_3d_body_entered(body: Node3D) -> void:
	if body is PlayerCharacter and !activated:
		animation_player.play("enter")
		spawn_point_sound.play()
		CheckpointManager.respawn_point = global_position
		activated = true
