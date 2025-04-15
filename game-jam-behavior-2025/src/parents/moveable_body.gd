class_name MoveableBody extends CharacterBody3D

const GRID_SIZE: int = 2

@export var gravity_influence: float = 1.0
@export var apply_gravity: bool = false

var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")

var root_motion_tween: Tween


func _physics_process(delta: float) -> void:
	if apply_gravity:
		velocity.y += -gravity * gravity_influence * delta

	move_and_slide()


func apply_root_motion(vel: Vector3, duration: float) -> void:
	if root_motion_tween:
		root_motion_tween.kill()

	root_motion_tween = create_tween()
	root_motion_tween.set_process_mode(Tween.TWEEN_PROCESS_PHYSICS)

	velocity = vel
	root_motion_tween.tween_interval(duration)
	root_motion_tween.tween_callback(func(): velocity = Vector3.ZERO)
	root_motion_tween.tween_callback(
		func(): global_position.x = snappedi(global_position.x, GRID_SIZE)
	)
	root_motion_tween.tween_callback(
		func(): global_position.z = snappedi(global_position.z, GRID_SIZE)
	)
