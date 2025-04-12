class_name PlayerCharacter extends CharacterBody3D


const GRID_SIZE: int = 2.0

const  idle_animation: StringName = &"Idle"
const run_animation: StringName = &"RunCycle"

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
		velocity += get_gravity() * gravity_influence
	
	move_and_slide()


func orient_character(direction: float, duration: float) -> void:
	var target_rot: float = deg_to_rad(90.0 * direction)
	
	if orient_tween:
		orient_tween.kill()
	orient_tween = create_tween()
	
	orient_tween.tween_property(character_mesh, "rotation:y", target_rot, duration)


#func apply_root_motion(target_pos: Vector3, duration: float) -> void:
	#if root_motion_tween:
		#root_motion_tween.kill()
	#
	#root_motion_tween = create_tween()
	#root_motion_tween.set_process_mode(Tween.TWEEN_PROCESS_PHYSICS)
	#
	#root_motion_tween.tween_property(self, "global_position", target_pos, duration)


func apply_horizontal_motion(x_destination: float, duration: float) -> void:
	if root_motion_tween:
		root_motion_tween.kill()
	root_motion_tween = create_tween()
	
	root_motion_tween.tween_property(self, "global_position:x", x_destination, duration)
	
	orient_character(input_direction, duration)


func _check_if_player_behind_wall() -> bool:
	var space_state = get_world_3d().direct_space_state
	var query = PhysicsRayQueryParameters3D.create(camera.global_position, pivot.global_position)
	var result = space_state.intersect_ray(query)
	
	if result:
		if result["collider"] != self:
			return true
	return false
