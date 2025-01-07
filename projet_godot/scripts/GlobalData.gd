extends Node

class_name GlobalData

# Constantes pour une meilleure lisibilité
const LIFE_LABEL_PATH = "../Camera2D/lifecounter"
const SHIELD_LABEL_PATH = "../Camera2D/shieldcounter"

# Variables statiques
static var lives: int = 99
static var shield: int = 1
static var instance: GlobalData

# Références aux nœuds
var life_label: Label
var shield_label: Label

func _ready() -> void:
	# Initialisation de l'instance unique
	instance = self

	# Chargement des nœuds
	life_label = get_node_or_null(LIFE_LABEL_PATH)
	shield_label = get_node_or_null(SHIELD_LABEL_PATH)

	# Mise à jour initiale des étiquettes
	update_life_label()
	update_shield_label()

func update_life_label() -> void:
	if life_label:
		life_label.text = "Lives: %d" % lives

func update_shield_label() -> void:
	if shield_label:
		shield_label.text = "Shield: %d" % shield

# Méthodes statiques pour gérer les vies
static func add_life() -> void:
	lives += 1
	instance.update_life_label()
	print("Life gained!")

static func lose_life() -> void:
	if lives > 0:
		lives -= 1
		instance.update_life_label()
		print("Life lost!")
	else:
		print("Game OVER!")

# Méthodes statiques pour gérer les boucliers
static func add_shield() -> void:
	shield += 1
	instance.update_shield_label()
	print("Shield gained!")

static func lose_shield() -> void:
	if shield > 0:
		shield -= 1
		instance.update_shield_label()
		print("Shield lost!")
	else:
		print("Game OVER!")
