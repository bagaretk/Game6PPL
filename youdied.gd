extends Node2D

func _ready() -> void:
	# If you did NOT enable "Autostart" in the Timer properties,
	# then start it here:
	$Timer.start()
	
	# Connect the timeout signal to a function in code:
	$Timer.timeout.connect(_on_timer_timeout)

func _on_timer_timeout() -> void:
	# After 3 seconds, automatically go to the MainMenu scene:
	get_tree().change_scene_to_file("res://menu.tscn")
