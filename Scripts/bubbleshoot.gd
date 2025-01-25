# BubbleShot.gd

extends Node2D

@export var speed: float = 600.0

# We'll store the direction here; default is up (0, -1).
var direction: Vector2 = Vector2.UP

func set_direction(new_direction: Vector2) -> void:
	# If the player is not moving (vector length = 0),
	# default to shooting straight up.
	if new_direction.length() == 0:
		direction = Vector2.UP
	else:
		direction = new_direction.normalized()

func _physics_process(delta: float) -> void:
	# Move in the assigned direction
	position += direction * speed * delta

	# Optional: if off-screen or some boundary, queue_free()
	if position.x > 2000:
		queue_free()

func _on_body_entered(body: Node) -> void:
	if body is Fish1 or body is Fish2 or body is Fish3:
		body.take_damage(1)  # each shot deals 1 damage
		queue_free()         # destroy bullet on collision
