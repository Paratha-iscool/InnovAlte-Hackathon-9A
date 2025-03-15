extends TextureButton
func _on_TextureButton_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/main_screen.tscn")
