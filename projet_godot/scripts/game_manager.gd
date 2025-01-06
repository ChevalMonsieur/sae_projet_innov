extends Node2D

enum STATE {STARTING, IN_GAME, PAUSE, DEATH_PLAYER, DEATH_AI, ENDED}

static var state: STATE = STATE.STARTING

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
