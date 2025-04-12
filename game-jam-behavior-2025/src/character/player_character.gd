class_name PlayerCharacter extends CharacterBody3D


const GRID_SIZE: int = 2.0

const  idle_animation: StringName = &"Idle"
const run_animation: StringName = &"RunCycle"
const fall_animation: StringName = &"FallCycle"

@export var move_duration: float = 0.5
@export var jump_force: float = 10.0
@export var gravity_influence: float = 1.0

var input_direction: int = 0
var apply_gravity: bool = false

var root_motion_tween: Tween
var orient_tween: Tween

var request_jump: bool = false

@onready var finite_state_machine: FiniteStateMachine = $FiniteStateMachine
@onready var character_mesh: Node3D = $character_v1
@onready var camera_pivot: Marker3D = $CameraPivot
@onready var camera: Camera3D = $CameraPivot/Camera3D
@onready var animation_tree: AnimationTree = $character_v1/AnimationTree
@onready var anime_state_machine: AnimationNodeStateMachinePlayback = animation_tree.get("parameters/playback")
@onready var pivot: Marker3D = $Pivot
@onready var visibility_component: Node3D = $VisibilityComponent


func _ready() -> void:
	finite_state_machine.start_machine(self)


func _physics_process(delta: float) -> void:
	if not visibility_component.is_visible_on_screen():
		finite_state_machine.switch_state(&"Death")
	
	input_direction = sign(Input.get_axis("ui_left", "ui_right"))
	request_jump = Input.is_action_just_pressed("ui_accept")
	
	finite_state_machine.update(delta)
	
	if apply_gravity:
		velocity += get_gravity() * gravity_influence * delta
	
	move_and_slide()


func orient_character(direction: Vector3, duration: float) -> void:
	var target_rot: float = direction.angle_to(Vector3.LEFT) - deg_to_rad(90.0)
	
	if orient_tween:
		orient_tween.kill()
	orient_tween = create_tween()
	
	orient_tween.tween_property(character_mesh, "rotation:y", target_rot, duration)


func apply_root_motion(vel: Vector3, duration: float) -> void:
	if root_motion_tween:
		root_motion_tween.kill()
	
	root_motion_tween = create_tween()
	root_motion_tween.set_process_mode(Tween.TWEEN_PROCESS_PHYSICS)
	
	velocity = vel
	root_motion_tween.tween_interval(duration)
	root_motion_tween.tween_callback(func(): velocity = Vector3.ZERO)
	
	orient_character(vel.normalized(), duration)
