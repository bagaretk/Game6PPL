extends CanvasLayer

var is_paused = false

func _ready():
	# Conectează semnalele butoanelor
	pass


func _on_pause_button_pressed():
	is_paused = true
	get_tree().paused = true  # Pune jocul pe pauză
	$Control.visible = true  # Arată meniul de pauză
	$Pause.visible = false  # Ascunde butonul de pauză
	$Control/Resume.visible = true
	$Control/Label.visible = true

func _on_resume_button_pressed():
	is_paused = false
	get_tree().paused = false  # Reia jocul
	$Control.visible = false  # Ascunde meniul de pauză
	$Control/Resume.visible = false  # Arată butonul de pauză
	$Pause.visible = true
	$Control/Label.visible = false


func _on_pause_pressed() -> void:
	_on_pause_button_pressed()


func _on_resume_pressed() -> void:
	_on_resume_button_pressed()
