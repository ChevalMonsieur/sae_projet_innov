extends Node


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var root = get_tree().root.get_child(0)
	if root is GameManager:
		GameManager.instance = root
