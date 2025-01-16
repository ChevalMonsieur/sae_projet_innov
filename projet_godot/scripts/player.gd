extends CharacterBody2D
class_name Player


@export var speed: float = 5
@export var base_position: Vector2 = Vector2.ZERO
@export var bullet_scene: Resource
@export var cooldown_bullet: float = .2
@export var max_shield: int = 5
@export var death_count: int = 0

@onready var sprite = $AnimatedSprite2D

var timer_bullet: float = cooldown_bullet
var shield: int = max_shield

func _ready() -> void:
	print(name)
	death_count = GameManager.total_deaths

func _physics_process(delta: float) -> void:
	if GameManager.current_state == GameManager.STATE.IN_GAME:
		check_movement()
		check_rotation()
		manage_shoot(delta)

func check_movement() -> void:
	velocity = Vector2.ZERO
	
	if (Input.is_key_pressed(KEY_Z)): velocity.y -= 1
	if (Input.is_key_pressed(KEY_S)): velocity.y += 1
	if (Input.is_key_pressed(KEY_Q)): velocity.x -= 1
	if (Input.is_key_pressed(KEY_D)): velocity.x += 1
	
	velocity = velocity.normalized() * speed
	move_and_slide()

func check_rotation() -> void:
	var mouse_pos = get_viewport().get_mouse_position()
	var direction = (mouse_pos - position).normalized()
	sprite.rotation = direction.angle() + PI/2

func manage_shoot(delta: float) -> void:
	timer_bullet -= delta
	
	if timer_bullet <= 0:
		timer_bullet += cooldown_bullet
		
		var bullet = bullet_scene.instantiate()
		bullet.creator = self
		bullet.position = position
		bullet.direction = (get_viewport().get_mouse_position() - position).normalized()
		
		GameManager.instance.projectiles.add_child(bullet)

func lose_shield_point() -> void:
	shield -= 1
	GameManager.instance.ui.current_shield = shield
	GameManager.instance.ui.update_hearts()
	print("Shield remaining: ", shield)
	
	if shield == 0:
		var timer = Timer.new()
		add_child(timer)
		timer.one_shot = true
		timer.wait_time = 0.1
		timer.start()
		await timer.timeout
		timer.queue_free()
		death_count += 1
		GameManager.total_deaths += 1
		GameManager.instance.ui.update_death_label()
		GameManager.instance.show_game_over()
		GameManager.current_state = GameManager.STATE.DEATH_PLAYER
	else:
		GameManager.instance.ui.update_hearts()
		print("Hearts updated")

func new_round() -> void:
	position = base_position
	shield = max_shield
	GameManager.instance.ui.current_shield = max_shield
	GameManager.instance.ui.update_hearts()
