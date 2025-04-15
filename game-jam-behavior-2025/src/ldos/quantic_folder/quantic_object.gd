@tool
extends Node3D
class_name Quantic_Object

@export var linked_object: Quantic_Object
@export var visibility_node: Visibility_Node
@export var switch_coll_node: SwitchableCollision

@export var activated: bool = true:
	set(value):
		if not linked_object or not visibility_node or not switch_coll_node:
			return

		if value != activated:
			activated = value
			linked_object.react(!activated)
			react(activated)


func _ready() -> void:
	if not Engine.is_editor_hint():
		visibility_node.on_screen_visibility_changed.connect(toggle)


func toggle(_is_visible_on_screen: bool):
	activated = !activated


func react(state: bool):
	switch_coll_node.toggle_state = state
