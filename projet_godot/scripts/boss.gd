extends CharacterBody2D
class_name Boss

@export var base_position: Vector2 = Vector2.ZERO

@export var speed: float = 5

@export var bullet_scene: PackedScene
@export var cooldown_bullet: float = .3

@export var max_shield: int = 5
@export var max_phases: int = 5

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var ai_controller: AIControllerCustom = $AIController2D

var timer_bullet: float = cooldown_bullet
var shield: int = max_shield

func game_over():
	ai_controller.done = true
	ai_controller.needs_reset = true

func _ready() -> void:
	print(name)
	print(ai_controller.heuristic)
	ai_controller.init(self)

func _physics_process(delta):
	if ai_controller.needs_reset:
		ai_controller.reset()
		return

	if GameManager.current_state == GameManager.STATE.IN_GAME:
		check_movement()
		check_rotation()
		manage_shoot(delta)
		
	elif GameManager.current_state == GameManager.STATE.DEATH_AI:
		sprite.play("destruction")
		if GameManager.current_round < GameManager.max_round:
			GameManager.current_state = GameManager.STATE.DEATH_AI_ANIM
		else:
			GameManager.current_round = GameManager.STATE.ENDED
	
	elif GameManager.current_state == GameManager.STATE.DEATH_AI_ANIM:
		if sprite.frame == 22:
			GameManager.new_round()
			GameManager.current_state = GameManager.STATE.IN_GAME

func check_movement() -> void:
	velocity = Vector2.ZERO
	
	if ai_controller.heuristic == "human":
		if (Input.is_key_pressed(KEY_UP)): velocity.y -= 1
		if (Input.is_key_pressed(KEY_DOWN)): velocity.y += 1
		if (Input.is_key_pressed(KEY_LEFT)): velocity.x -= 1
		if (Input.is_key_pressed(KEY_RIGHT)): velocity.x += 1
	else: 
		velocity = ai_controller.move_action
		print("move_input: " + str(velocity))
	
	velocity = velocity.normalized() * speed
	move_and_slide()

func check_rotation() -> void:
	var player_position = GameManager.instance.player.global_position
	var direction = player_position - global_position
	sprite.rotation = direction.angle() + PI/2

func manage_shoot(delta: float) -> void:
	timer_bullet -= delta
	
	if timer_bullet <= 0:
		timer_bullet += cooldown_bullet
		
		var bullet = bullet_scene.instantiate()
		print(self)
		bullet.creator = self
		bullet.position = position
		print(ai_controller.heuristic)
		if ai_controller.heuristic == "human": 
			bullet.direction = (GameManager.instance.player.global_position - position).normalized()
		else:
			bullet.direction = ai_controller.shoot_direction_action
			print("shoot_direction_input: " + str(bullet.direction))
		GameManager.instance.bullets.add_child(bullet)

func lose_shield_point() -> void:
	print("lose shield point" + str(shield))
	shield -= 1
	reward_ai(-1)
	
	if shield < 0:
		reward_ai(-10)
		GameManager.current_state = GameManager.STATE.DEATH_AI
		ai_controller.done = true
		ai_controller.needs_reset = true

func reward_ai(amount: float) -> void:
	ai_controller.reward += amount

func new_round() -> void:
	sprite.play("idle")
	match GameManager.current_round:
		1:
			max_shield = 5
			cooldown_bullet = .5
			shield = max_shield
			speed = 50
		_:
			max_shield = GameManager.current_round * 10
			cooldown_bullet = 0.5 / GameManager.current_round
			shield = max_shield
			speed = min(GameManager.current_round * 50, 200)
