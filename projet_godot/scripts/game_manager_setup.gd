extends Node

func _ready() -> void:
	GameManager.instance = get_tree().root.get_child(0)
