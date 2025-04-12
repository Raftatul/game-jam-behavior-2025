extends Node


func _ready() -> void:
	CheckpointManager.respawn_point = $Character.global_position


func _on_play_on_screen_visibility_changed(is_visible: bool) -> void:
	if not is_visible:
		get_tree().change_scene_to_file("res://src/levels/map_charles.tscn")


func _on_credits_on_screen_visibility_changed(is_visible: bool) -> void:
	if not is_visible:
		pass


func _on_quit_on_screen_visibility_changed(is_visible: bool) -> void:
	if not is_visible:
		get_tree().quit()
