#Player.gd

extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -400.0

func _physics_process(delta: float) -> void:
	# Obține direcția de intrare pe axele X și Y
	var direction_x := Input.get_axis("ui_left", "ui_right")
	var direction_y := Input.get_axis("ui_up", "ui_down")

	# Setează viteza pe baza direcției
	velocity.x = direction_x * SPEED
	velocity.y = direction_y * SPEED

	# Aplica mișcarea
	move_and_slide()
