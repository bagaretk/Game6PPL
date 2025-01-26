extends CharacterBody2D

class_name HealthBubble

@export var speed: float = 100.0
@export var wave_amplitude: float = 50.0
@export var wave_frequency: float = 2.0

var time: float = 0.0

func _physics_process(delta: float) -> void:
	time += delta

	# Calculate horizontal and vertical movement
	var dx = sin(time * wave_frequency) * wave_amplitude * delta
	var dy = -speed * delta

	# Update the position manually
	position += Vector2(dx, dy)
