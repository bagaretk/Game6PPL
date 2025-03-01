extends CharacterBody2D

class_name Fish3

@export var speed: float = 100.0
var hp: int = 5  # Enemy3 can take 5 hits

func _physics_process(delta: float) -> void:
	position.x -= speed * delta  # Manually adjust position based on speed and delta time

func take_damage(amount: int) -> void:
	hp -= amount
	if hp <= 0:
		queue_free()
