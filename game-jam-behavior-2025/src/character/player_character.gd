class_name PlayerCharacter extends CharacterBody3D


const GRID_SIZE: int = 2.0

const  idle_animation: StringName = &"Idle"
const run_animation: StringName = &"RunCycle"
const fall_animation: StringName = &"FallCycle"

@export var move_duration: float = 0.5
@export var jump_force: float = 10.0
@export var gravity_influence: float = 1.0
@export var dash_duration: float = 0.5
@export var dash_distance: float = 6.0

var input_direction: Vector2 = Vector2.ZERO
var las_valid_input: Vector2 = Vector2.RIGHT

var apply_gravity: bool = false

var root_motion_tween: Tween
var orient_tween: Tween

var request_jump: bool = false
var request_dash: bool = false

@onready var finite_state_machine: FiniteStateMachine = $FiniteStateMachine
@onready var top_down_state_machine: FiniteStateMachine = $TopDownStateMachine
@onready var camera_pivot: CameraController = $CameraPivot

@onready var animation_tree: AnimationTree = $character_v1/AnimationTree
@onready var anime_state_machine: AnimationNodeStateMachinePlayback = animation_tree.get("parameters/playback")

@onready var character_mesh: Node3D = $character_v1
@onready var camera: Camera3D = $CameraPivot/Camera3D
@onready var pivot: Marker3D = $Pivot
@onready var visibility_component: Node3D = $VisibilityComponent


func _ready() -> void:
	finite_state_machine.start_machine(self)
	top_down_state_machine.start_machine(self)


func _physics_process(delta: float) -> void:
	if not visibility_component.is_visible_on_screen():
		if camera_pivot.camera_state_machine.current_state_name == &"2D":
			finite_state_machine.switch_state(&"Death")
		else:
			top_down_state_machine.switch_state(&"Death")
	
	input_direction = Vector2(sign(Input.get_axis("ui_left", "ui_right")), sign(Input.get_axis("ui_up", "ui_down")))
	
	if input_direction:
		las_valid_input = input_direction
	
	request_jump = Input.is_action_just_pressed("ui_accept")
	request_dash = Input.is_action_just_pressed("dash")
	
	if camera_pivot.camera_state_machine.current_state_name == &"2D":
		finite_state_machine.update(delta)
	else:
		top_down_state_machine.update(delta)
	
	if apply_gravity:
		velocity += get_gravity() * gravity_influence * delta
	
	move_and_slide()


func set_rot(alpha: float, start_ang: float, target_ang: float) -> void:
	character_mesh.rotation.y = lerp_angle(start_ang, target_ang, alpha)


func orient_character(direction: Vector3, duration: float) -> void:
	var current_ang: float = character_mesh.rotation.y
	var target_ang: float = atan2(direction.x, direction.z)
	
	if orient_tween:
		orient_tween.kill()
	orient_tween = create_tween()
	
	orient_tween.tween_method(set_rot.bind(current_ang, target_ang), 0.0, 1.0, duration)
	#orient_tween.tween_property(character_mesh, "rotation:y", target_ang, duration)


func apply_root_motion(vel: Vector3, duration: float) -> void:
	if root_motion_tween:
		root_motion_tween.kill()
	
	root_motion_tween = create_tween()
	root_motion_tween.set_process_mode(Tween.TWEEN_PROCESS_PHYSICS)
	
	velocity = vel
	root_motion_tween.tween_interval(duration)
	root_motion_tween.tween_callback(func(): velocity = Vector3.ZERO)
	root_motion_tween.tween_callback(func(): global_position.x = snappedi(global_position.x, GRID_SIZE))
	root_motion_tween.tween_callback(func(): global_position.z = snappedi(global_position.z, GRID_SIZE))
	
	orient_character(vel.normalized(), duration)
