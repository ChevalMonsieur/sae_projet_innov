extends Control

@export var current_level_label: Label
@export var total_levels_label: Label
@export var quit: Label
@export var total_deaths: Label
@export var completion_time: Label

static var stats = GameManager.stats_for_win_scene
static var current_round  = stats[0]
static var max_round  = stats[1]
static var game_total_deaths = stats[2]
static var total_time = stats[3]

func _ready() -> void:
	
	quit.text = "Press Escape to quit the game!"

	current_level_label.text = "Current Level: "
	total_levels_label.text = "Total Levels Passed: "
	
	
	set_stats()
	
func set_stats() -> void:
	current_level_label.text = "Current Level: " + str(current_round)
	total_levels_label.text = "Total Levels Passed: " + str(max_round + 1)
	total_deaths.text = str(game_total_deaths)
	
	var minutes = int(total_time) / 60
	var seconds = int(total_time) % 60
	completion_time.text = "Completion Time: %02d:%02d" % [minutes, seconds]

func _process(_delta):
	if Input.is_key_pressed(KEY_ESCAPE):
		quit_game()
	
func quit_game():
	get_tree().quit()
