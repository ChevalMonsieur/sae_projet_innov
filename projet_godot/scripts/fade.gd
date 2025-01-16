extends ColorRect


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if GameManager.current_state == GameManager.STATE.ENDED:
		print(color)
		color.a += delta
		if color.a >= 1:
			GameManager.instance.show_win()
