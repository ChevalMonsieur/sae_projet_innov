extends CharacterBody2D

@export var speed: float = 5
@export var bullet_scene: Resource
@export var cooldown_bullet: float = .2
@export var max_shield: int = 5

var timer_bullet: float = cooldown_bullet
var shield: int = max_shield

func _physics_process(delta: float) -> void:
	if GameManager.current_state == GameManager.STATE.IN_GAME:
		check_movement()
		manage_shoot(delta)

func check_movement() -> void:
	velocity = Vector2.ZERO
	
	if (Input.is_key_pressed(KEY_Z)): velocity.y -= 1
	if (Input.is_key_pressed(KEY_S)): velocity.y += 1
	if (Input.is_key_pressed(KEY_Q)): velocity.x -= 1
	if (Input.is_key_pressed(KEY_D)): velocity.x += 1
	
	velocity = velocity.normalized() * speed
	move_and_slide()

func manage_shoot(delta: float) -> void:
	timer_bullet -= delta
	
	if timer_bullet <= 0:
		timer_bullet += cooldown_bullet
		
		var bullet = bullet_scene.instantiate()
		bullet.instantiator = self
		bullet.position = position
		bullet.direction = (get_viewport().get_mouse_position() - position).normalized()
		$"../bullets".add_child(bullet)

func lose_shield_point() -> void:
	print("lose shield point")
	shield -= 1
	if shield < 0:
		print("death")
		GameManager.current_state = GameManager.STATE.DEATH_PLAYER
