class_name PlayerCharacter extends MoveableBody


const  idle_animation: StringName = &"Idle"
const run_animation: StringName = &"RunCycle"
const fall_animation: StringName = &"FallCycle"

@export var move_duration: float = 0.5
@export var jump_force: float = 10.0
@export var dash_duration: float = 0.5
@export var dash_distance: float = 6.0

var input_direction: Vector2 = Vector2.ZERO
var last_valid_input: Vector2 = Vector2.RIGHT

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
		kill()
	
	input_direction = Vector2(sign(Input.get_axis("ui_left", "ui_right")), sign(Input.get_axis("ui_up", "ui_down")))
	
	if input_direction:
		last_valid_input = input_direction
	
	request_jump = Input.is_action_just_pressed("ui_accept")
	request_dash = Input.is_action_just_pressed("dash")
	
	if camera_pivot.camera_state_machine.current_state_name == &"2D":
		finite_state_machine.update(delta)
	else:
		top_down_state_machine.update(delta)
	
	#for i in range(get_slide_collision_count()):
		#if not get_slide_collision(i).get_collider() is MoveableBody:
			#continue
		#
		#var moveable_body: MoveableBody = get_slide_collision(i).get_collider()
		#if moveable_body:
			#moveable_body.apply_root_motion((Vector3(last_valid_input.x, 0.0, last_valid_input.y) * 2.0) / move_duration, move_duration)
	#
	super(delta)


func kill() -> void:
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
	#orient_tween.tween_property(character_mesh, "rotation:y", target_ang, duration)


func apply_root_motion(vel: Vector3, duration: float) -> void:
	super(vel, duration)
	orient_character(vel.normalized(), duration)
