extends Node2D

@export var speed: float = 5

var creator: Node2D
var direction: Vector2 = Vector2.ZERO

func _ready() -> void:
	rotation = direction.angle() + PI / 2

func _physics_process(_delta: float) -> void:
	if GameManager.current_state == GameManager.STATE.IN_GAME:
		position += direction * speed

		if position.x > get_viewport_rect().size.x or position.x < 0 or position.y > get_viewport_rect().size.y or position.y < 0:
			queue_free()

func _on_body_entered(body: Node2D) -> void:
	if (body is Player or body is Boss) and body != creator:
		body.lose_shield_point()
		queue_free()
