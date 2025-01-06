extends Node2D

const game_manager = preload("res://scripts/game_manager.gd")

@export var speed: float = 5
@export var bullet_scene: Resource
@export var cooldown_bullet: float = .2

var timer_bullet: float = cooldown_bullet

func _physics_process(delta: float) -> void:
	if game_manager.current_state == game_manager.STATE.IN_GAME:
		check_movement()
		manage_shoot(delta)
	else:
		print(game_manager.current_state)

func check_movement() -> void:
	var movement = Vector2.ZERO
	if (Input.is_key_pressed(KEY_Z)): movement.y -= 1
	if (Input.is_key_pressed(KEY_S)): movement.y += 1
	if (Input.is_key_pressed(KEY_Q)): movement.x -= 1
	if (Input.is_key_pressed(KEY_D)): movement.x += 1
	position += movement.normalized() * speed

func manage_shoot(delta: float) -> void:
	timer_bullet -= delta
	
	if timer_bullet <= 0:
		timer_bullet += cooldown_bullet
		
		var bullet = bullet_scene.instantiate()
		bullet.position = position
		bullet.direction = (get_viewport().get_mouse_position() - position).normalized()
		$"../bullets".add_child(bullet)
