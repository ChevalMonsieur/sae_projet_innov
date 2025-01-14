extends Node2D
class_name GameManager

enum STATE {STARTING, IN_GAME, PAUSE, DEATH_PLAYER, DEATH_AI, DEATH_AI_ANIM, ENDED}

@export var player: Player
@export var boss: Boss
@export var ui: UI
@export var bullets: Node

static var instance: GameManager

static var current_state: STATE
static var state_before_pause: STATE

static var max_round: int = 4
static var current_round: int = 1

static var game_over_stats: Array = []

func _ready() -> void:
	print(name)

	current_state = STATE.IN_GAME
	instance = self
	
func new_round() -> void:
	current_round += 1
	$player.new_round()
	$boss.new_round()
	GameManager.instance.ui.update_boss_health_bar($boss.shield, $boss.max_shield)
	for bullet in $bullets.get_children():
		bullet.queue_free()

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("pause"):
		if current_state != STATE.PAUSE:
			state_before_pause = current_state
			current_state = STATE.PAUSE
		else: 
			current_state = state_before_pause
			
func show_game_over():
	var boss_health = boss.shield
	var boss_max_health = boss.max_shield

	# Instancie la scène Game Over
	get_tree().change_scene_to_file("res://scenes/prefabs/gameOver.tscn")
	game_over_stats = [boss_health, boss_max_health]
