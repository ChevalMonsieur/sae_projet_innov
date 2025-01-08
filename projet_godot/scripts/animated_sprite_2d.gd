extends AnimatedSprite2D

var boss = preload("res://scenes/boss.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	play("default")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if frame == 13:
		GameManager.current_state = GameManager.STATE.IN_GAME
		var instance = boss.instantiate()
		get_tree().root.add_child(instance)
		queue_free()
