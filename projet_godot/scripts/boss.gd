extends CharacterBody2D

class_name Boss
@export var speed: float = 5
@export var bullet_scene: Resource
@export var cooldown_bullet: float = .3
@export var max_shield: int = 5
@export var max_phases: int = 5
@export var destruction: PackedScene
@onready var sprite = $AnimatedSprite2D
@onready var player = get_node("../player")

var timer_bullet: float = cooldown_bullet
var shield: int = max_shield
var phase: int = 1

func _ready() -> void:
	match GameManager.current_phase:
		1:
			max_shield = 5
			cooldown_bullet = .5
			shield = max_shield
			speed = 50
		_:
			max_shield = GameManager.current_phase * 10
			cooldown_bullet = 0.5 / GameManager.current_phase
			shield = max_shield
			speed = min(GameManager.current_phase * 50, 200)

func _physics_process(delta):
	if GameManager.current_state == GameManager.STATE.IN_GAME:
		check_movement()
		check_rotation()
		manage_shoot(delta)
	if GameManager.current_state == GameManager.STATE.DEATH_AI:
		if GameManager.current_phase < GameManager.max_phase:
			GameManager.current_phase += 1
			var instance = destruction.instantiate()
			get_tree().root.add_child(instance)
			queue_free()
		else: 
			GameManager.current_state = GameManager.STATE.DEATH_AI
	
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
		bullet.instantiatorr = self
		bullet.position = position
		bullet.direction = (player.global_position - position).normalized()
		$"../bullets".add_child(bullet)

func lose_shield_point() -> void:
	print("lose shield point" + str(shield))
	shield -= 1
	
	if shield < 0:
		print("Phase : ", phase, " done")
		GameManager.current_state = GameManager.STATE.DEATH_AI
