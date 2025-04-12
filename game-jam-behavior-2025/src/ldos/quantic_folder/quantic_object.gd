@tool
extends RigidBody3D
class_name Quantic_Object

var linked_object: Quantic_Object

@export var activated:bool = true:
	get(): return activated
	set(value): 
		if value != activated:
			if linked_object:
				linked_object._react()
			$SwitchableCollisionShape3D.switch()
			activated = value


func toggle():
	activated = !activated


func _react():
	$SwitchableCollisionShape3D.switch()


func _on_visibility_component_on_screen_visibility_changed(visible: bool) -> void:
	toggle()
