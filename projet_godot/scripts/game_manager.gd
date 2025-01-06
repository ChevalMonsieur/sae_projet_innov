extends Node2D

enum STATE {STARTING, IN_GAME, PAUSE, DEATH_PLAYER, DEATH_AI, ENDED}

static var current_state: STATE

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	current_state = STATE.IN_GAME

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
