@icon("state_node.svg")
class_name State extends Node


func set_common_node(_common_node) -> void:
	pass


func check_relevance() -> StringName:
	return ""


func enter(_machine: FiniteStateMachine) -> void:
	pass


func update(_machine: FiniteStateMachine, _delta: float) -> void:
	pass


func exit(_machine: FiniteStateMachine) -> void:
	pass
