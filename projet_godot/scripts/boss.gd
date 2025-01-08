extends CharacterBody2D

class_name Boss
@export var speed: float = 5
@export var bullet_scene: Resource
@export var cooldown_bullet: float = .3
@export var max_shield: int = 5
@export var max_phases: int = 5

@onready var sprite = $AnimatedSprite2D
@onready var player = get_node("../player")

var timer_bullet: float = cooldown_bullet
var shield: int = max_shield
var phase: int = 1


func _physics_process(delta):
	if GameManager.current_state == GameManager.STATE.IN_GAME:
		check_movement()
		check_rotation()
		manage_shoot(delta)
	if GameManager.current_state == GameManager.STATE.DEATH_AI:
		if phase <= max_phases:
			next_phase()
		else: 
			GameManager.current_state = GameManager.STATE.DEATH_AI
		
func next_phase() -> void:
	phase += 1
	max_shield += 3
	shield = max_shield
	cooldown_bullet -= 0.1
	speed += 50
	GameManager.current_state = GameManager.STATE.IN_GAME
	
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
		bullet.instantiator = self
		bullet.position = position
		bullet.direction = (player.global_position - position).normalized()
		$"../bullets".add_child(bullet)

func lose_shield_point() -> void:
	print("lose shield point" + str(shield))
	shield -= 1
	
	if shield < 0:
		print("Phase : ", phase, " done")
		next_phase()
		GameManager.current_state = GameManager.STATE.DEATH_AI
