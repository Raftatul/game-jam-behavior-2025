extends MeshInstance3D


@export var target: Node3D


func _ready() -> void:
	if target:
		target.visibility_changed.connect(_on_visibility_changed)


func _on_visibility_changed() -> void:
	if target:
		visible = !target.visible
