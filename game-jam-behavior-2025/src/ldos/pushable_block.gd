extends RigidBody3D

@export var push_amount:int = 2


func _on_body_entered(body: Node) -> void:
	if (body is PlayerCharacter):
		body.GRID_SIZE
