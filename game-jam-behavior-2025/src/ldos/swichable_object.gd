extends CollisionShape3D

@onready var timer: Timer = $Timer

@export var switching_interval:float = 5
@export var use_custom_behavior:bool
@export var toggle_meshes:MeshInstance3D

var toggle_state:bool

signal onToggle(blocking:bool)

func _ready() -> void:
	timer.wait_time = switching_interval
	
	timer.timeout.connect(switch)
	
	if (timer.paused):
		timer.paused = false
	elif (timer.is_stopped()):
		timer.start()

func switch():
	print("Test")
	
	toggle_state = !toggle_state
	
	if (owner is PhysicsBody3D):
		owner.collision_layer = 1 if toggle_state else 2
	
	onToggle.emit(toggle_state)
	
	if !use_custom_behavior and toggle_meshes :
		toggle_meshes.visible = toggle_state
