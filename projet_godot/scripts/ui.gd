extends Control
class_name UI

var max_shield : int = 5
var current_shield : int = max_shield

@export var heart_container: HBoxContainer
@export var heart_scene : PackedScene
@export var boss_health_bar: ProgressBar


@export var death_container: HBoxContainer
@export var skull_scene : PackedScene
@export var death_count_label: Label

static var skull: Node = null

func _ready() -> void:
	print(name)
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

func update_death_label(is_label_visible: bool = true) -> void:
	if death_count_label:
		death_count_label.visible = is_label_visible && GameManager.total_deaths > 0
		if is_label_visible && GameManager.total_deaths > 0:
			death_count_label.text = "%d" % GameManager.total_deaths

	if GameManager.total_deaths > 0:
		if skull == null:
			print("Instanciation du crâne...")
			skull = skull_scene.instantiate()
			add_child(skull)

			if skull.has_node("AnimatedSprite2D"):
				var skull_sprite = skull.get_node("AnimatedSprite2D")
				skull_sprite.scale = Vector2(0.8, 0.8)
				skull_sprite.position.x += 630
				skull_sprite.position.y += 20
				skull_sprite.play("skull")
	else:
		if death_count_label:
			death_count_label.visible = false
		if skull:
			skull.queue_free()
			skull = null
				
func update_boss_health_bar(health: int, max_health: int = -1) -> void:
	if boss_health_bar:
		if max_health > 0:
			boss_health_bar.max_value = max_health
			
		boss_health_bar.value = clamp(health, 0, boss_health_bar.max_value)
		boss_health_bar.visible = health > 0
