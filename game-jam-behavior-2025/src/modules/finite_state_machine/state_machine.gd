@icon("state_machine.svg")
@tool
class_name FiniteStateMachine extends Node


signal state_entered(state_name: StringName)
signal state_exited(state_name: StringName)

var current_state_name: StringName
var current_state: State

@export var debug_transition: bool = false

@export var initial_state: State :
	set(value):
		initial_state = value
		if Engine.is_editor_hint():
			update_configuration_warnings()

var states: Dictionary[StringName, State]


#region Editor

func _get_configuration_warnings():
	if initial_state == null:
		return ["Initial state is null!"]
	return []

#endregion


func start_machine(common_node) -> void:
	for child in get_children():
		if child is State:
			states[child.name] = child
			child.set_common_node(common_node)
	
	if is_instance_valid(initial_state):
		current_state_name = initial_state.name
		current_state = initial_state
		current_state.enter(self)


func update(delta: float) -> void:
	if not is_instance_valid(current_state):
		return
	var relevance: StringName = current_state.check_relevance()
	if relevance != "":
		switch_state(relevance)
		switch_state.rpc(relevance)
	current_state.update(self, delta)


@rpc("any_peer", "reliable")
func switch_state(new_state_name: StringName) -> void:
	if new_state_name == current_state_name:
		return
	
	var new_state: State = states[new_state_name] if states.has(new_state_name) else null
	
	if is_instance_valid(new_state):
		#Exit current state
		current_state.exit(self)
		state_exited.emit(new_state_name)
		
		#Switch to new state
		current_state_name = new_state_name
		current_state = new_state
		
		if debug_transition:
			printt("Enter", new_state_name, "state")
		
		#Enter new state
		current_state.enter(self)
		state_entered.emit(new_state_name)
	else:
		push_error("StateNode '", new_state_name, "' not found. (", get_path(), ")")
