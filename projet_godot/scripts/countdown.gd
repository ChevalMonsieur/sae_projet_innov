extends Node

signal countdown_finished
var countdown_time = 5
var timer
var go_timer 
var is_countdown_running = false
var countdown_label: Label

func _ready():
	timer = Timer.new()
	add_child(timer)
	timer.wait_time = 1
	timer.timeout.connect(_on_Timer_timeout)
	
	go_timer = Timer.new() 
	add_child(go_timer)
	go_timer.wait_time = 1
	go_timer.one_shot = true  
	go_timer.timeout.connect(_on_go_timer_timeout)
	
	countdown_label = $Label
	countdown_label.hide()
	countdown_label.text = str(countdown_time)
	
func start_countdown():
	if not is_countdown_running:
		countdown_time = 5
		is_countdown_running = true
		countdown_label.show()
		countdown_label.text = str(countdown_time)
		timer.start()

func _on_Timer_timeout():
	countdown_time -= 1
	countdown_label.text = str(countdown_time)
	if countdown_time <= 0:
		timer.stop()
		is_countdown_running = false
		countdown_label.text = "GO!"
		emit_signal("countdown_finished")
		go_timer.start()

func _on_go_timer_timeout():
	countdown_label.text = ""
	countdown_label.hide()
