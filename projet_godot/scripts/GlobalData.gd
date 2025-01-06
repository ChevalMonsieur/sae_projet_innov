extends Node

class_name GlobalData

static var lives: int = 99
static var shield: int = 1
static var instance: GlobalData
var life_label: Label
var shield_label: Label

func _ready() -> void:
	instance = self
	
	life_label = get_node("../Camera2D/lifecounter")
	shield_label = get_node("../Camera2D/shieldcounter")
	update_life_label()
	update_shield_label()

func update_life_label() -> void:
	if life_label:
		life_label.text = "Lives: %d" % lives
		
func update_shield_label() -> void:
	if shield_label:
		shield_label.text = "Shield: %d" % shield

static func add_life() -> void:
	lives += 1
	instance.update_life_label()
	print("Life gained!")
	
static func add_shield() -> void:
	shield += 1
	instance.update_shield_label()
	print("Shield gained!")

static func lose_life() -> void:
	if lives > 0:
		lives -= 1
		instance.update_life_label()
		print("Une vie perdue !")
	else:
		print("Game OVER !")

static func lose_shield() -> void:
	if shield > 0:
		shield -= 1
		instance.update_shield_label()
		print("You lost 1 shield!")
	else:
		print("Game OVER !")
