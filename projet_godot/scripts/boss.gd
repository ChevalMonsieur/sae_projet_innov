extends CharacterBody2D
class_name Boss

@export var base_position: Vector2 = Vector2.ZERO

@export var speed: float = 5

@export var bullet_scene: PackedScene
@export var cooldown_bullet: float = .3

@export var max_shield: int = 5
@export var max_phases: int = 5

@onready var lance_missile_scene: PackedScene = preload("res://scenes/prefabs/lance_missile.tscn")
@onready var sprite = $AnimatedSprite2D

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
			GameManager.current_round = GameManager.STATE.ENDED
	
	elif GameManager.current_state == GameManager.STATE.DEATH_AI_ANIM:
		if sprite.frame == 22:
			GameManager.instance.new_round()
			GameManager.current_state = GameManager.STATE.IN_GAME
			
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
	var player_position = GameManager.instance.player.global_position
	var direction = player_position - global_position
	get_child(0).rotation = direction.angle() + PI/2
	get_child(1).rotation = direction.angle() + PI/2
	
	
func manage_shoot(delta: float) -> void:
	timer_bullet -= delta
	
	if timer_bullet <= 0:
		timer_bullet += cooldown_bullet
		
		var bullet = bullet_scene.instantiate()
		bullet.creator = self
		bullet.position = position
		bullet.direction = (GameManager.instance.player.global_position - position).normalized()
		GameManager.instance.projectiles.add_child(bullet)

func lose_shield_point() -> void:
	print("lose shield point" + str(shield))
	shield -= 1
	GameManager.instance.ui.update_boss_health_bar(shield)
	
	if shield < 0:
		GameManager.current_state = GameManager.STATE.DEATH_AI
		
func new_round() -> void:
	for child in get_children():
		if child is LanceMissile:
			child.queue_free()
	
	match GameManager.current_round:
		1:
			sprite.play("boss_1")
			max_shield = 5
			cooldown_bullet = 5
			shield = max_shield
			speed = 50
			find_child("CollisionShape2D").shape.size = Vector2(4.8, 4.4)
		2:
			sprite.play("boss_2")
			max_shield = GameManager.current_round * 10
			cooldown_bullet = 0.5 / GameManager.current_round
			shield = max_shield
			speed = min(GameManager.current_round * 50, 200)
			
			find_child("CollisionShape2D").shape.size = Vector2(7.2, 7.8)
			
			var lance_missile_1: LanceMissile = lance_missile_scene.instantiate()
			var lance_missile_2: LanceMissile = lance_missile_scene.instantiate()
			lance_missile_1.position = Vector2(-15, -1)
			lance_missile_2.position = Vector2(15, -1)
			add_child(lance_missile_1)
			add_child(lance_missile_2)
		3:
			sprite.play("boss_3")
			max_shield = GameManager.current_round * 10
			cooldown_bullet = 0.5 / GameManager.current_round
			shield = max_shield
			speed = min(GameManager.current_round * 50, 200)
			
			find_child("CollisionShape2D").shape.size = Vector2(11.2, 4.4)
			
			var lance_missile_1: LanceMissile = lance_missile_scene.instantiate()
			var lance_missile_2: LanceMissile = lance_missile_scene.instantiate()
			lance_missile_1.position = Vector2(-26, -8)
			lance_missile_2.position = Vector2(26, -8)
			lance_missile_1.timer_cooldown = 1
			lance_missile_2.timer_cooldown = 1
			add_child(lance_missile_1)
			add_child(lance_missile_2)
		4:
			sprite.play("boss_4")
			max_shield = GameManager.current_round * 10
			cooldown_bullet = 0.5 / GameManager.current_round
			shield = max_shield
			speed = min(GameManager.current_round * 50, 200)
			
			find_child("CollisionShape2D").shape.size = Vector2(14.4, 17.4)
			
			var lance_missile_1: LanceMissile = lance_missile_scene.instantiate()
			var lance_missile_2: LanceMissile = lance_missile_scene.instantiate()
			var lance_missile_3: LanceMissile = lance_missile_scene.instantiate()
			var lance_missile_4: LanceMissile = lance_missile_scene.instantiate()
			lance_missile_1.position = Vector2(-30, -6)
			lance_missile_2.position = Vector2(30, -6)
			lance_missile_3.position = Vector2(-19, -36)
			lance_missile_4.position = Vector2(19, -36)
			lance_missile_1.rotation_speed = 0.02
			lance_missile_2.rotation_speed = 0.02
			lance_missile_3.rotation_speed = 0.02
			lance_missile_4.rotation_speed = 0.02
			add_child(lance_missile_1)
			add_child(lance_missile_2)
			add_child(lance_missile_3)
			add_child(lance_missile_4)
		5:
			sprite.play("boss_5")
			max_shield = GameManager.current_round * 10
			cooldown_bullet = 0.5 / GameManager.current_round
			shield = max_shield
			speed = min(GameManager.current_round * 50, 200)
			find_child("CollisionShape2D").shape.size = Vector2(14.4, 20)
		_:
			sprite.play("boss_5")
			max_shield = GameManager.current_round * 10
			cooldown_bullet = 0.5 / GameManager.current_round
			shield = max_shield
			speed = min(GameManager.current_round * 50, 200)
			find_child("CollisionShape2D").shape.size = Vector2(14.4, 20)
