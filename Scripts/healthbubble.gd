# HealthBubble.gd
extends CharacterBody2D

@export var speed: float = 100.0
@export var wave_amplitude: float = 50.0   # How far left/right it moves
@export var wave_frequency: float = 2.0    # How quickly it oscillates horizontally

var time := 0.0

func _physics_process(delta: float) -> void:
	time += delta
	# Move up:
	velocity.y = -speed

	# Add a wave motion on the x-axis:
	# You can use sine for smooth left-right oscillation.
	velocity.x = sin(time * wave_frequency) * wave_amplitude

	move_and_slide()

	# If the enemy goes off the top of the screen by some margin, remove it.
	if position.y < -100.0:
		queue_free()
