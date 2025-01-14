extends CharacterBody2D
class_name Boss

@export var speed: float = 5
@export var base_position: Vector2 = Vector2.ZERO
@export var bullet_scene: PackedScene
@export var cooldown_bullet: float = .3
@export var max_shield: int = 5
@export var max_phases: int = 5

@onready var sprite = $AnimatedSprite2D
@onready var player = get_node("../player")

var timer_bullet: float = cooldown_bullet
var shield: int = max_shield

func _ready():
	sprite.animation_finished.connect(_on_animation_finished)

func _physics_process(delta):
	if GameManager.current_state == GameManager.STATE.IN_GAME:
		check_movement()
		check_rotation()
		manage_shoot(delta)
		
	elif GameManager.current_state == GameManager.STATE.DEATH_AI:
		sprite.play(sprite.animation + "_destruction")
		if GameManager.current_round <= GameManager.max_round:
			GameManager.current_state = GameManager.STATE.DEATH_AI_ANIM
		else:
			GameManager.current_state = GameManager.STATE.ENDED

func _on_animation_finished():
	print("Animation finished:", sprite.animation)
	print("Current state:", GameManager.current_state)
	if GameManager.current_state == GameManager.STATE.DEATH_AI_ANIM:
		print("Starting new round")
		GameManager.instance.new_round()


func check_movement() -> void:
	velocity = Vector2.ZERO
	
	if (Input.is_key_pressed(KEY_UP)): velocity.y -= 1
	if (Input.is_key_pressed(KEY_DOWN)): velocity.y += 1
	if (Input.is_key_pressed(KEY_LEFT)): velocity.x -= 1
	if (Input.is_key_pressed(KEY_RIGHT)): velocity.x += 1
	
	velocity = velocity.normalized() * speed
	move_and_slide()

func check_rotation() -> void:
	var player_position = player.global_position
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
		bullet.direction = (player.global_position - position).normalized()
		$"../bullets".add_child(bullet)

func lose_shield_point() -> void:
	print("lose shield point" + str(shield))
	shield -= 1
	
	if shield < 0:
		GameManager.current_state = GameManager.STATE.DEATH_AI
		
func new_round() -> void:
	
	match GameManager.current_round:
		1:
			sprite.play("boss_1")
			max_shield = 5
			cooldown_bullet = .5
			shield = max_shield
			speed = 50
		2:
			sprite.play("boss_2")
			max_shield = GameManager.current_round * 10
			cooldown_bullet = 0.5 / GameManager.current_round
			shield = max_shield
			speed = min(GameManager.current_round * 50, 200)
		3:
			sprite.play("boss_3")
			max_shield = GameManager.current_round * 10
			cooldown_bullet = 0.5 / GameManager.current_round
			shield = max_shield
			speed = min(GameManager.current_round * 50, 200)
		4:
			sprite.play("boss_4")
			max_shield = GameManager.current_round * 10
			cooldown_bullet = 0.5 / GameManager.current_round
			shield = max_shield
			speed = min(GameManager.current_round * 50, 200)
		5:
			sprite.play("boss_5")
			max_shield = GameManager.current_round * 10
			cooldown_bullet = 0.5 / GameManager.current_round
			shield = max_shield
			speed = min(GameManager.current_round * 50, 200)
		_:
			sprite.play("boss_5")
			max_shield = GameManager.current_round * 10
			cooldown_bullet = 0.5 / GameManager.current_round
			shield = max_shield
			speed = min(GameManager.current_round * 50, 200)
