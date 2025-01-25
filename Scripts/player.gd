extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -400.0

# Limitele de mișcare (modifică valorile pentru a se potrivi cu scena ta)
const LIMIT_LEFT = -10000.0
const LIMIT_RIGHT = 10000.0
const LIMIT_TOP = -500000.0
const LIMIT_BOTTOM = 800.0

func _physics_process(delta: float) -> void:
	# Obține direcția de intrare pe axele X și Y
	var direction_x := Input.get_axis("ui_left", "ui_right")
	var direction_y := Input.get_axis("ui_up", "ui_down")

	# Setează viteza pe baza direcției
	velocity.x = direction_x * SPEED
	velocity.y = direction_y * SPEED

	# Aplica mișcarea
	move_and_slide()

	# Verifică și limitează poziția playerului
	global_position.x = clamp(global_position.x, LIMIT_LEFT, LIMIT_RIGHT)
	global_position.y = clamp(global_position.y, LIMIT_TOP, LIMIT_BOTTOM)
