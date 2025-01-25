# Enemy1.gd
extends CharacterBody2D

@export var speed: float = 400.0

func _physics_process(delta: float) -> void:
	# Move horizontally at 'speed' pixels per second (leftward for example).
	velocity.x = -speed
	move_and_slide()
