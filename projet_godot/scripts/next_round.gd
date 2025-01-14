extends Control

signal display_finished

var display_timer: Timer

func _ready():
	hide()
	display_timer = Timer.new()
	add_child(display_timer)
	display_timer.wait_time = 3
	display_timer.one_shot = true
	display_timer.timeout.connect(_on_display_timer_timeout)

func show_next_round():
	$level.text = "Level " + str(GameManager.current_round)
	$boss.texture = load("res://sprites/boss/Kla'ed/Base/PNGs/boss_" + str(GameManager.current_round) + ".png")
	show()
	display_timer.start()

func _on_display_timer_timeout():
	hide()
	emit_signal("display_finished")
