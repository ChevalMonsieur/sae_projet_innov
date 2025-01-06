extends Node2D


const game_manager = preload("res://scripts/game_manager.gd")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta: float) -> void:
	if (game_manager.current_state == game_manager.STATE.IN_GAME):
		if (Input.is_key_pressed(KEY_Z)):
			position.y = position.y-1
		if (Input.is_key_pressed(KEY_S)):
			position.y = position.y+1
		if (Input.is_key_pressed(KEY_Q)):
			position.x = position.x-1
		if (Input.is_key_pressed(KEY_D)):
			position.x = position.x+1
	else:
		print(game_manager.current_state)
	
		
	
