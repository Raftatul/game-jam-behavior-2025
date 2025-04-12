#@tool
extends Node3D

signal on_screen_visibility_changed(visible:bool)

#@export_tool_button("Place Points") var event = _place_points

@export var points: Array[Node3D]

var state: bool = true :
	set(value):
		if value != state:
			on_screen_visibility_changed.emit(value)
		state = value

var camera: Node3D


func _ready() -> void:
	if not Engine.is_editor_hint():
		camera = get_viewport().get_camera_3d()


func _physics_process(delta: float) -> void:
	#if not Engine.is_editor_hint():
		#if self.is_on_screen():
	state = is_visible_on_screen()


#func _place_points() -> void:
	#for i in range(clamp(points.size(),0,4)):
		#var point_position : Vector3
		#var bb : AABB = self.aabb
		#
		#point_position.z = bb.position.z + bb.size.z/2
		#point_position.x = bb.position.x + bb.size.x if i > 1 else bb.position.x
		#point_position.y = bb.position.y + bb.size.y if i < 1 or i > 2 else bb.position.y
		#
		#points[i].position = point_position


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
