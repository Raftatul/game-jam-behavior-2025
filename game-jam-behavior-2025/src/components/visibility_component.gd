extends Node3D


@export var points: Array[Node3D]

var camera: Node3D


func _ready() -> void:
	camera = get_viewport().get_camera_3d()


func is_visible_on_screen() -> bool:
	var space_state = get_world_3d().direct_space_state
	
	for point in points:
		var query = PhysicsRayQueryParameters3D.create(camera.global_position, point.global_position, 1)
		var result = space_state.intersect_ray(query)
		
		if result:
			if result["collider"] == owner:
				return true
		else:
			return true
	return false
