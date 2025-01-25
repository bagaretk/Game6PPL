extends CharacterBody2D

class_name HealthBubble

@export var speed: float = 100.0
@export var wave_amplitude: float = 50.0
@export var wave_frequency: float = 2.0

var time := 0.0

func _physics_process(delta: float) -> void:
	time += delta

	velocity.y = -speed
	velocity.x = sin(time * wave_frequency) * wave_amplitude

	move_and_slide()
