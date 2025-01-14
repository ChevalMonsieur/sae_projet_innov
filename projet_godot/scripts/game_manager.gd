extends Node2D
class_name GameManager

enum STATE {STARTING, IN_GAME, PAUSE, DEATH_PLAYER, DEATH_AI, DEATH_AI_ANIM, ENDED}

@export var training: bool
@export var player: Player
@export var boss: Boss
@export var boss2: Boss
@export var ui: UI
@export var bullets: Node

static var instance: GameManager

static var current_state: STATE
static var state_before_pause: STATE

static var max_round: int = 4
static var current_round: int = 0

func _ready() -> void:
	print(name)
	new_round()

	current_state = STATE.IN_GAME
	instance = self
	
static func new_round() -> void:
	current_round += 1
	if instance.training:
		GameManager.instance.boss2.new_round()
	else:
		GameManager.instance.player.new_round()
	GameManager.instance.boss.new_round()
	for bullet in GameManager.instance.bullets.get_children():
		bullet.queue_free()

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("pause"):
		if current_state != STATE.PAUSE:
			state_before_pause = current_state
			current_state = STATE.PAUSE
		else: 
			current_state = state_before_pause
