extends Node2D

func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/todo.tscn")


func _on_alters_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/alters.tscn")


func _on_info_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/info.tscn")


func _on_timeline_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/timeline.tscn")


func _on_talk_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/talk.tscn")
