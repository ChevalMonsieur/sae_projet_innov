extends Node2D
class_name GameManager

enum STATE {STARTING, IN_GAME, PAUSE, DEATH_PLAYER, DEATH_AI}

static var current_state: STATE
static var state_before_pause: STATE
static var instance: Node2D

func _ready() -> void:
	current_state = STATE.IN_GAME
	instance = self

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("pause"):
		if current_state != STATE.PAUSE:
			state_before_pause = current_state
			current_state = STATE.PAUSE
		else: 
			current_state = state_before_pause
