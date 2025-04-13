extends Node3D

var focused:bool = false
@export var trigger: Area3D

func _ready() -> void:
	trigger.body_entered.connect(thing)


func _physics_process(delta: float) -> void:
	if focused:
		self.look_at(get_tree().get_first_node_in_group("player").global_position)

func thing(area: Node3D):
	if area is PlayerCharacter:
		focused = true
