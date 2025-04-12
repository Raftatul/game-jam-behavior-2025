class_name CameraController extends Marker3D


@export var player: PlayerCharacter
@export var switch_duration: float = 0.5

var request_switch: bool = false

var switch_tween: Tween

@onready var camera_state_machine: FiniteStateMachine = $CameraStateMachine


func _ready() -> void:
	camera_state_machine.start_machine(self)


func _physics_process(delta: float) -> void:
	if player.finite_state_machine.current_state_name != &"Death":
		request_switch = Input.is_action_just_pressed("switch_camera")
	
	camera_state_machine.update(delta)


func switch_to_2d() -> void:
	switch_tween = create_tween()
	
	switch_tween.tween_property(self, "rotation:x", deg_to_rad(-10.0), switch_duration)


func switch_to_topdown() -> void:
	switch_tween = create_tween()
	
	switch_tween.tween_property(self, "rotation:x", deg_to_rad(-90.0), switch_duration)
