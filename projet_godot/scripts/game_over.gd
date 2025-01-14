extends Control

@export var game_over_label: Label
@export var current_level_label: Label
@export var total_levels_label: Label
@export var restart_label: Label
@export var boss_health_bar: ProgressBar

func _ready():
	game_over_label.text = "Game Over"
	restart_label.text = "Press R to restart the game!"

	current_level_label.text = "Current Level: "
	total_levels_label.text = "Total Levels Passed: "
	
	set_stats()
	
func set_stats() -> void:
	game_over_label.text = "Game Over"

	current_level_label.text = "Current Level: " + str(GameManager.current_round)

	total_levels_label.text = "Total Levels Passed: " + str(GameManager.current_round - 1)
	
	boss_health_bar.max_value = GameManager.game_over_stats[1]
	boss_health_bar.value = GameManager.game_over_stats[0]

func _process(_delta):
	if Input.is_key_pressed(KEY_R):
		restart_game()

func restart_game():
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
