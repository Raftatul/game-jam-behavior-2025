@tool
extends CollisionShape3D
class_name SwitchableCollision

enum SWITCH_MODE {TIMED,PASSIVE}

signal onToggle(blocking:bool)

@export var switch_mode: SWITCH_MODE = SWITCH_MODE.PASSIVE
@export var switching_interval: float = 5
@export var use_custom_behavior: bool
@export var disable_collision: bool = true
@export var toggle_meshes: Node3D

@export var toggle_state: bool :
	set(value):
		toggle_state = value
		onToggle.emit(toggle_state)
		
		if (get_parent() is PhysicsBody3D):
			get_parent().collision_layer = 1 if toggle_state else 2
			if disable_collision:
				get_parent().process_mode = Node.PROCESS_MODE_DISABLED if !toggle_state else Node.PROCESS_MODE_INHERIT
		
		if toggle_state:
			if !use_custom_behavior and toggle_meshes :
				toggle_meshes.visible = toggle_state
		else:
			if !use_custom_behavior and toggle_meshes :
				toggle_meshes.visible = toggle_state

@onready var timer: Timer = $Timer


func _ready() -> void:
	if switch_mode == SWITCH_MODE.PASSIVE:
		return
	
	timer.wait_time = switching_interval
	
	timer.timeout.connect(switch)
	
	if (timer.paused):
		timer.paused = false
	elif (timer.is_stopped()):
		timer.start()


func switch():
	toggle_state = !toggle_state
