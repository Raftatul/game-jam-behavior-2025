class_name CameraController extends Marker3D


@export var player: PlayerCharacter
@export var switch_duration: float = 0.5

@export var side_angle: float = -10.0 :
	get:
		return deg_to_rad(side_angle)
	
@export var topdown_angle: float = -90.0 :
	get:
		return deg_to_rad(topdown_angle)

@export var curve: Curve

var request_switch: bool = false

var switch_tween: Tween

var trans: float = 0.0

@onready var camera_state_machine: FiniteStateMachine = $CameraStateMachine


func _ready() -> void:
	camera_state_machine.start_machine(self)


func _physics_process(delta: float) -> void:
	if player.finite_state_machine.current_state_name != &"Death" and player.top_down_state_machine.current_state_name != &"Death":
		request_switch = Input.is_action_just_pressed("switch_camera")
	
	camera_state_machine.update(delta)


func rotate_camera(alpha: float, start_angle: float, angle: float,) -> void:
	rotation.x = lerpf(start_angle, angle, curve.sample(alpha))


func switch_to_2d() -> void:
	switch_tween = create_tween()
	
	switch_tween.tween_method(rotate_camera.bind(rotation.x, side_angle), 0.0, 1.0, switch_duration)


func switch_to_topdown() -> void:
	switch_tween = create_tween()
	
	switch_tween.tween_method(rotate_camera.bind(rotation.x, topdown_angle), 0.0, 1.0, switch_duration)
