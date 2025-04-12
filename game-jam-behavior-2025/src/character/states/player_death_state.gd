extends PlayerState


@export var reload_delay: float = 1.0

var timer: Timer


func _ready() -> void:
	timer = Timer.new()
	timer.timeout.connect(_on_timer_timeout)
	
	add_child(timer)


func check_relevance() -> StringName:
	return ""


func enter(machine: FiniteStateMachine) -> void:
	timer.start()
	player.apply_gravity = false
	player.velocity = Vector3.ZERO
	
	if player.root_motion_tween:
		player.root_motion_tween.kill()


func _on_timer_timeout() -> void:
	get_tree().reload_current_scene()
