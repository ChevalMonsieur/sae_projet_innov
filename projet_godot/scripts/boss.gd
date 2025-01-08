extends CharacterBody2D

@export var speed: float = 5
@export var bullet_scene: Resource
@export var cooldown_bullet: float = .2
@export var max_shield: int = 5

@onready var sprite = $AnimatedSprite2D
@onready var player = get_node("../player")

var timer_bullet: float = cooldown_bullet
var shield: int = max_shield


func _physics_process(delta):
	if GameManager.current_state == GameManager.STATE.IN_GAME:
		check_movement()
		check_rotation()
		manage_shoot(delta)
	
func check_movement() -> void:
	pass	

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
	print("lose shield point")
	shield -= 1
	if shield < 0:
		print("death")
		GameManager.current_state = GameManager.STATE.DEATH_PLAYER

	
	
