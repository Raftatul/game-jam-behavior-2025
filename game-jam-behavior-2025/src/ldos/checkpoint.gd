extends Node3D


@export var lerp_speed: float = 0.05


var player: PlayerCharacter

@onready var animation_player: AnimationPlayer = $Checkpoint/AnimationPlayer
@onready var spawn_point_sound: AudioStreamPlayer = $SpawnPointSound
@onready var mesh_instance_3d: MeshInstance3D = $MeshInstance3D
@onready var spawn_point: Marker3D = $Area3D/SpawnPoint

var activated:bool = false


func _process(_delta: float) -> void:
	if player:
		var direction: Vector3 = player.pivot.global_position - mesh_instance_3d.global_position
		var basis_target = Basis.looking_at(direction, Vector3.UP, true)

		mesh_instance_3d.global_basis = mesh_instance_3d.global_basis.slerp(basis_target, lerp_speed)


func _on_area_3d_body_entered(body: Node3D) -> void:
	if body is PlayerCharacter and !activated:
		animation_player.play("enter")
		spawn_point_sound.play()
		CheckpointManager.respawn_point = spawn_point.global_position
		activated = true
		player = body
