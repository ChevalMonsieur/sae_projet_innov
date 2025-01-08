extends Control
class_name UI

@export var shield_points_label: Label
@export var death_count_label: Label

static var instance: Control

func _ready() -> void:
	instance = self
	update_shield_label()
	update_death_label(false)

static func update_shield_label() -> void:
	instance.shield_points_label.text = "Shield points: %d" % Player.instance.shield

static func update_death_label(visible: bool = true) -> void:
	if instance.death_count_label:
		instance.death_count_label.visible = visible
		if visible and Player.instance:
			instance.death_count_label.text = "Deaths: %d" % Player.instance.death_count
