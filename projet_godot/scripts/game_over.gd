extends Control

@export var game_over_label: Label
@export var current_level_label: Label
@export var total_levels_label: Label
@export var restart_label: Label
@export var quit: Label
@export var boss_health_bar: ProgressBar
@export var boss_life_remaining: Label

func _ready():
	game_over_label.text = "Game Over"
	restart_label.text = "Press R to restart the game!"
	quit.text = "Or Press Escape to quit the game!"

	current_level_label.text = "Current Level: "
	total_levels_label.text = "Total Levels Passed: "
	boss_life_remaining.text = "Boss life remaining :"
	
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
	elif Input.is_key_pressed(KEY_ESCAPE):
		load_main_menu()

func restart_game():
	GameManager.current_round = 1
	GameManager.current_state = GameManager.STATE.STARTING
	GameManager.game_over_stats = []
	get_tree().change_scene_to_file("res://scenes/actual_game.tscn")
	
func load_main_menu():
	get_tree().quit()
