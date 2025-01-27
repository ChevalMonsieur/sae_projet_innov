extends Node2D
class_name GameManager

enum STATE {STARTING, IN_GAME, PAUSE, DEATH_PLAYER, DEATH_AI, DEATH_AI_ANIM, ENDED}

@export var player: Player
@export var boss: Boss
@export var ui: UI
@export var projectiles: Node

static var instance: GameManager

static var current_state: STATE
static var state_before_pause: STATE

static var max_round: int = 4
static var current_round: int = 1

var starting_initialized = false 

static var game_over_stats: Array = []
static var stats_for_win_scene : Array = []
static var total_deaths: int = 0

static var game_start_time: float = 0.0
static var game_end_time: float = 0.0
static var total_play_time: float = 0.0

func _ready() -> void:
	$Next_round.hide()
	$countdown.countdown_finished.connect(_on_countdown_finished)
	$Next_round.display_finished.connect(_on_next_round_display_finished)
	current_state = STATE.STARTING
	instance = self
	if boss:
		boss.new_round()
	if ui and player:
		ui.update_death_label(true)
		if boss:
			ui.update_boss_health_bar(boss.shield, boss.max_shield)
	
	
func _physics_process(delta: float) -> void:
	# print("Current state : ", STATE.keys()[current_state])
	if current_state == STATE.STARTING and not starting_initialized:
		starting_initialized = true 
		$player.new_round()
		$boss.new_round()
		$Next_round.show_next_round()
		
func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("pause"):
		if current_state != STATE.PAUSE:
			state_before_pause = current_state
			current_state = STATE.PAUSE
		else: 
			current_state = state_before_pause
			
func new_round() -> void:
	current_round += 1
	player.new_round()
	boss.new_round()
	GameManager.instance.ui.update_boss_health_bar($boss.shield, $boss.max_shield)
	for bullet in projectiles.get_children():
		bullet.queue_free()
	current_state = STATE.STARTING
	starting_initialized = false
	
func _on_countdown_finished():
	if current_round == 1:
		game_start_time = Time.get_unix_time_from_system()
	current_state = STATE.IN_GAME
	
func _on_next_round_display_finished():
	print("start countdown")
	$countdown.start_countdown()
			
func show_game_over():
	var boss_health = boss.shield
	var boss_max_health = boss.max_shield

	boss.shield = boss.max_shield
	boss.cooldown_bullet = boss.cooldown_bullet
	GameManager.instance.ui.update_boss_health_bar(boss.shield, boss.max_shield)

	game_over_stats = [boss_health, boss_max_health]

	get_tree().change_scene_to_file("res://scenes/prefabs/gameOver.tscn")
	
func show_win():
	game_end_time = Time.get_unix_time_from_system()
	total_play_time = game_end_time - game_start_time
	stats_for_win_scene = [current_round, max_round, total_deaths, total_play_time]
	get_tree().change_scene_to_file("res://scenes/prefabs/win.tscn")
