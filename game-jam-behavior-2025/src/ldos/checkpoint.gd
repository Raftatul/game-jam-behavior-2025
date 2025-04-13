extends Node3D


var player: PlayerCharacter

@onready var animation_player: AnimationPlayer = $Checkpoint/AnimationPlayer
@onready var spawn_point_sound: AudioStreamPlayer = $SpawnPointSound
@onready var mesh_instance_3d: MeshInstance3D = $MeshInstance3D

var activated:bool = false


func _process(delta: float) -> void:
	if player:
		mesh_instance_3d.look_at(player.pivot.global_position, Vector3.UP, true)


func _on_area_3d_body_entered(body: Node3D) -> void:
	if body is PlayerCharacter and !activated:
		animation_player.play("enter")
		spawn_point_sound.play()
		CheckpointManager.respawn_point = global_position
		activated = true
		player = body
