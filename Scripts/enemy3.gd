# Enemy3.gd
extends CharacterBody2D

@export var speed: float = 100.0

func _physics_process(delta: float) -> void:
	velocity.x = -speed
	move_and_slide()
