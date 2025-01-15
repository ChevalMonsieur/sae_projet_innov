extends Node2D

var rotation_speed: float = 0.01
var speed: float = 0.01

var creator: Node2D
var target: Node2D
var direction: Vector2 = Vector2.ZERO

func _ready() -> void:
	if creator is Player:
		target = GameManager.instance.boss
	else: 
		target = GameManager.instance.player

func _physics_process(delta: float) -> void:
	var delta_direction: float = (target.position - position).angle() - direction.angle()
	print(delta_direction)
	if delta_direction <= rotation_speed: direction = (target.position - position)
	else: direction.rotated(rotation_speed * sign(delta_direction))
	direction = direction.normalized()
	
	rotation = direction.angle() + PI / 2

	if GameManager.current_state == GameManager.STATE.IN_GAME:
		position += direction * speed * delta
	if position.x > get_viewport_rect().size.x or position.x < 0 or position.y > get_viewport_rect().size.y or position.y < 0:
		queue_free()
