extends Node2D

@export var timer_cooldown: float = 2
@export var speed: float = 200
@export var rotation_speed: float = 0.01
@export var missile_scene: PackedScene

var timer: float = 2

func _ready() -> void:
	pass
	
func _physics_process(delta: float) -> void:
	if GameManager.current_state == GameManager.STATE.IN_GAME:
		timer -= delta
		if timer <= 0:
			timer += timer_cooldown
			
			var missile = missile_scene.instantiate()
			missile.creator = get_parent()
			missile.position = global_position
			missile.speed = speed
			print()
			missile.direction = (GameManager.instance.player.global_position - position).normalized()
			GameManager.instance.projectiles.add_child(missile)
