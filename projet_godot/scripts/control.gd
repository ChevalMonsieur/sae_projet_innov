extends Control
class_name UI

@export var max_shield : int = 5
var current_shield : int = max_shield

@export var heart_container: HBoxContainer
@export var heart_scene : PackedScene

@export var death_container: HBoxContainer
@export var skull_scene : PackedScene
@export var death_count_label: Label

static var instance: Control
static var skull: Node = null

func _ready() -> void:
	instance = self
	update_death_label(false)
	update_hearts()
	
	for child in heart_container.get_children():
		child.queue_free()
	
	for i in range(max_shield):
		var heart = heart_scene.instantiate()
		heart.name = "Heart" + str(i)
		heart.position.x += i*55
		heart_container.add_child(heart)

	
func update_hearts() -> void:
	print("Current shield: ", current_shield)
	var i := 1
	for child in heart_container.get_children():
		if i <= current_shield:
			print("Setting heart ", i, " to full")
			child.play("heart_full")
		else:
			print("Setting heart ", i, " to empty")
			child.play("heart_empty")
		i+=1

func update_death_label(visible: bool = true) -> void:
	if instance.death_count_label:
		instance.death_count_label.visible = visible
		if visible and Player.instance:
			instance.death_count_label.text = "%d" % Player.instance.death_count

	if Player.instance.death_count > 0:
		if skull == null:
			print("Instanciation du crâne...")
			skull = UI.instance.skull_scene.instantiate()
			instance.add_child(skull)

			if skull.has_node("AnimatedSprite2D"):
				var skull_sprite = skull.get_node("AnimatedSprite2D")
				skull_sprite.scale = Vector2(0.8, 0.8)  # Réduction de la taille
				skull_sprite.position.x += 630
				skull_sprite.position.y += 20
				skull_sprite.play("skull")
