extends Node2D

class_name GameManager

enum STATE {STARTING, IN_GAME, PAUSE, DEATH_PLAYER, DEATH_AI, ENDED}

static var current_state: STATE
static var instance: Node2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	current_state = STATE.IN_GAME
	instance = self
