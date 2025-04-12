class_name PlayerCharacter extends CharacterBody3D


const GRID_SIZE: int = 2.0

@export var move_duration: float = 0.5
@export var jump_force: float = 10.0

var input_direction: int = 0
var apply_gravity: bool = false

var root_motion_tween: Tween

var request_jump: bool = false

@onready var finite_state_machine: FiniteStateMachine = $FiniteStateMachine


func _ready() -> void:
	finite_state_machine.start_machine(self)


func _process(delta: float) -> void:
	input_direction = sign(Input.get_axis("ui_left", "ui_right"))


func _physics_process(delta: float) -> void:
	request_jump = Input.is_action_just_pressed("ui_accept")
	
	finite_state_machine.update(delta)
	
	if apply_gravity:
		velocity += get_gravity()
	
	move_and_slide()


func apply_root_motion(target_pos: Vector3, duration: float) -> void:
	if root_motion_tween:
		root_motion_tween.kill()
	
	root_motion_tween = create_tween()
	root_motion_tween.set_process_mode(Tween.TWEEN_PROCESS_PHYSICS)
	
	root_motion_tween.tween_property(self, "global_position", target_pos, duration)


func apply_horizontal_motion(x_destination: float, duration: float) -> void:
	if root_motion_tween:
		root_motion_tween.kill()
	
	root_motion_tween = create_tween()
	root_motion_tween.set_process_mode(Tween.TWEEN_PROCESS_PHYSICS)
	
	root_motion_tween.tween_property(self, "global_position:x", x_destination, duration)
