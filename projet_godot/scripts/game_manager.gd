extends Node2D

class_name GameManager

enum STATE {STARTING, IN_GAME, PAUSE, DEATH_PLAYER, DEATH_AI, DEATH_AI_ANIM, ENDED}

static var current_state: STATE
static var max_round: int = 4
static var current_round: int = 1
static var instance: GameManager
var starting_initialized = false 

func _ready() -> void:
	$Next_round.hide()
	$countdown.countdown_finished.connect(_on_countdown_finished)
	$Next_round.display_finished.connect(_on_next_round_display_finished)
	current_state = STATE.STARTING
	instance = self
	
func _physics_process(delta: float) -> void:
	print("Current state : ", STATE.keys()[current_state])
	if current_state == STATE.STARTING and not starting_initialized:
		starting_initialized = true 
		$player.new_round()
		$boss.new_round()
		$Next_round.show_next_round()
	
func new_round() -> void:
	current_round += 1
	for bullet in $bullets.get_children():
		bullet.queue_free()
	current_state = STATE.STARTING
	starting_initialized = false
	
func _on_countdown_finished():
	current_state = STATE.IN_GAME
	
func _on_next_round_display_finished():
	print("start countdown")
	$countdown.start_countdown()
