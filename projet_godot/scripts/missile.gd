extends Node2D

var rotation_speed: float = 0.01
var speed: float = 0.01

var creator: Node2D
var target: Node2D

var current_direction: Vector2 = Vector2.ZERO
var direction_to_target: Vector2 = Vector2.ZERO
var delta_direction: float = 0

func _ready() -> void:
	if creator is Player:
		target = GameManager.instance.boss
	else: 
		target = GameManager.instance.player
	current_direction = (target.position - position).normalized()

func _physics_process(delta: float) -> void:
	direction_to_target = (target.position - position).normalized()
	delta_direction = (current_direction.dot(direction_to_target) * 90 - 90) * -1
	

	if rotation_speed >= delta_direction:
		current_direction = direction_to_target
	else:
		if (current_direction.orthogonal().dot(direction_to_target) * 90 - 90) * -1 >= 90:
			current_direction = current_direction.rotated(rotation_speed)
		else: 
			current_direction = current_direction.rotated(-rotation_speed)

	rotation = (current_direction.orthogonal()).angle()

	if GameManager.current_state == GameManager.STATE.IN_GAME:
		position += current_direction * speed * delta
	if position.x > get_viewport_rect().size.x or position.x < 0 or position.y > get_viewport_rect().size.y or position.y < 0:
		queue_free()


func _on_body_entered(body: Node2D) -> void:
	if (body is Player or body is Boss) and body != creator:
		body.lose_shield_point()
		queue_free()
