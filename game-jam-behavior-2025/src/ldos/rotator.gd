extends Node3D

@export var showInGame: bool = false
@onready var rotation_point: Sprite3D = $RotationPoint

@export var rotating_angle: axis = axis.x
@export var rotating_speed: float = 10
enum axis {x,y,z}

func _ready() -> void:
	if (!showInGame):
		rotation_point.visible = false

func _process(delta: float) -> void:
	var rotation_amount = delta * rotating_speed
	
	match rotating_angle:
		axis.x:
			self.rotate(self.global_basis.x, rotation_amount)
		axis.y:
			self.rotate(self.global_basis.y, rotation_amount)
		axis.z:
			self.rotate(self.global_basis.z, rotation_amount)
