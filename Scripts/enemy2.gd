# Enemy2.gd
extends CharacterBody2D

@export var speed: float = 250.0

func _physics_process(delta: float) -> void:
	velocity.x = -speed
	move_and_slide()

	
