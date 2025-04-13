@tool
extends RigidBody3D
class_name Quantic_Object

@export var linked_object: Quantic_Object
@export var visibility_node:Visibility_Node
@export var switch_coll_node:SwitchableCollision


@export var activated:bool = true:
	set(value): 
		if value != activated:
			if linked_object:
				linked_object._react()
			switch_coll_node.switch()
			activated = value


func _ready() -> void:
	if Engine.is_editor_hint():
		visibility_node.on_screen_visibility_changed.connect(toggle)

func toggle():
	activated = !activated


func _react():
	switch_coll_node.switch()
