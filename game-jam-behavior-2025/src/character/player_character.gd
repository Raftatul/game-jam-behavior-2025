class_name PlayerCharacter extends MoveableBody

const idle_animation: StringName = &"Idle"
const run_animation: StringName = &"RunCycle"
const fall_animation: StringName = &"FallCycle"
const dash_animation: StringName = &"Dash"

@export var move_duration: float = 0.5
@export var jump_force: float = 10.0
@export var dash_duration: float = 0.5
@export var dash_distance: float = 6.0

@export var can_switch_camera: bool = true

var input_direction: Vector2 = Vector2.ZERO
var last_valid_input: Vector2 = Vector2.RIGHT

var orient_tween: Tween

var request_jump: bool = false
var request_dash: bool = false

@onready var finite_state_machine: FiniteStateMachine = $FiniteStateMachine
@onready var top_down_state_machine: FiniteStateMachine = $TopDownStateMachine
@onready var camera_pivot: CameraController = $CameraPivot

@onready var animation_tree: AnimationTree = $character_v1/AnimationTree
@onready var anime_state_machine: AnimationNodeStateMachinePlayback = animation_tree.get(
	"parameters/playback"
)

@onready var character_mesh: Node3D = $character_v1
@onready var camera: Camera3D = $CameraPivot/Camera3D
@onready var pivot: Marker3D = $Pivot
@onready var dash_vfx: CPUParticles3D = $character_v1/DashVfx

@onready var dash: AudioStreamPlayer = $Dash
@onready var death: AudioStreamPlayer = $Death
@onready var jump_land: AudioStreamPlayer = $JumpLand
@onready var jump_start: AudioStreamPlayer = $JumpStart
@onready var step_1_reverb: AudioStreamPlayer = $Step1Reverb
@onready var step_sounds_anim: AnimationPlayer = $StepSoundsAnim

@onready var death_player: AnimationPlayer = $CanvasLayer/ColorRect/DeathPlayer
@onready var fade_screen: AnimationPlayer = $CanvasLayer/ColorRect2/FadeScreen


func _ready() -> void:
	fade_screen.play("death", -1, -1.0, true)
	finite_state_machine.start_machine(self)
	top_down_state_machine.start_machine(self)

	# await get_tree().process_frame

	global_position = CheckpointManager.respawn_point


func _physics_process(delta: float) -> void:
	input_direction = Vector2(
		sign(Input.get_axis("ui_left", "ui_right")), sign(Input.get_axis("ui_up", "ui_down"))
	)

	if input_direction:
		last_valid_input = input_direction

	request_jump = Input.is_action_just_pressed("ui_accept")
	request_dash = Input.is_action_just_pressed("dash")

	if camera_pivot.camera_state_machine.current_state_name == &"2D":
		finite_state_machine.update(delta)
	else:
		top_down_state_machine.update(delta)

	velocity += get_platform_velocity()

	super(delta)


func get_last_valid_input_direction() -> Vector3:
	return Vector3(last_valid_input.x, 0.0, last_valid_input.y).rotated(
		Vector3.UP, global_rotation.y
	)


func kill() -> void:
	camera_pivot.switch_tween.kill()

	if camera_pivot.camera_state_machine.current_state_name == &"2D":
		finite_state_machine.switch_state(&"Death")
	else:
		top_down_state_machine.switch_state(&"Death")


func set_rot(alpha: float, start_ang: float, target_ang: float) -> void:
	character_mesh.rotation.y = lerp_angle(start_ang, target_ang, alpha)


func orient_character(direction: Vector3, duration: float) -> void:
	var current_ang: float = character_mesh.rotation.y
	var target_ang: float = atan2(direction.x, direction.z)

	if orient_tween:
		orient_tween.kill()
	orient_tween = create_tween()

	orient_tween.tween_method(set_rot.bind(current_ang, target_ang), 0.0, 1.0, duration)


func apply_root_motion(vel: Vector3, duration: float) -> void:
	super(vel, duration)
	orient_character(vel.normalized(), duration)


func _on_visibility_component_on_screen_visibility_changed(is_visible_on_screen: bool) -> void:
	if not is_visible_on_screen:
		kill()
