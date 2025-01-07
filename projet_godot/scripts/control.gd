extends Control
class_name UI

@export var shield_points_label: Label

static var instance: Control

func _ready() -> void:
	instance = self
	update_shield_label()

static func update_shield_label() -> void:
	instance.shield_points_label.text = "Shield points: %d" % Player.instance.shield
