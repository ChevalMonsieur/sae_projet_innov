extends Node2D

@export var speed: float = 5

var direction: Vector2 = Vector2.ZERO



func _physics_process(_delta: float) -> void:
	position += direction * speed
	
	if position.x > get_viewport_rect().size.x or position.x < 0 or position.y > get_viewport_rect().size.y or position.y < 0:
		print("killed bullet")
		queue_free()
