extends Node2D

class_name GameManager

enum STATE {STARTING, IN_GAME, PAUSE, DEATH_PLAYER, DEATH_AI, DEATH_AI_ANIM, ENDED}

static var current_state: STATE
static var max_round: int = 4
static var current_round: int = 1
static var instance: GameManager

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	current_state = STATE.IN_GAME
	instance = self
	
func new_round() -> void:
	current_round += 1
	$player.new_round()
	$boss.new_round()
	for bullet in $bullets.get_children():
		bullet.queue_free()
