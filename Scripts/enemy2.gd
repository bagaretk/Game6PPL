extends CharacterBody2D

class_name Fish2

@export var speed: float = 250.0
var hp: int = 4  # Enemy2 can take 4 hits

func _physics_process(delta: float) -> void:
	velocity.x = -speed
	move_and_slide()

func take_damage(amount: int) -> void:
	hp -= amount
	if hp <= 0:
		queue_free()
