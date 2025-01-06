extends Control

func _on_play_button_up() -> void:
	print('load scene')
	get_tree().change_scene_to_file("res://scenes/actual_game.tscn")


func _on_quit_button_up() -> void:
	print('quit game')
	get_tree().quit()
