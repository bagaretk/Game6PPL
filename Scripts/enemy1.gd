extends CharacterBody2D

class_name Fish1;

@export var speed: float = 400.0
var hp: int = 3  # Enemy1 can take 3 hits

func _physics_process(delta: float) -> void:
	velocity.x = -speed
	move_and_slide()

func take_damage(amount: int) -> void:
	hp -= amount
	if hp <= 0:
		queue_free()  # remove enemy from the scene
