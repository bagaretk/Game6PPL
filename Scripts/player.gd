extends CharacterBody2D

#@onready var flash_animation = $FlashAnimation
@onready var health_bar = $Camera2D/LayerBar/HealthBar
@onready var health_timer = $HealthTimer # Referință la Timer-ul pentru scăderea vieții

const SPEED = 300.0
const JUMP_VELOCITY = -400.0

# Limitele de mișcare (modifică valorile pentru a se potrivi cu scena ta)
const LIMIT_LEFT = -10000.0
const LIMIT_RIGHT = 10000.0
const LIMIT_TOP = -500000.0
const LIMIT_BOTTOM = 800.0

var hp = 10

func _ready():
	health_bar.value = hp
	health_timer.start(1.0)  # Pornește timer-ul pentru scăderea vieții (1 secunda)

func _on_add_health_pressed():
	hp += 1
	health_bar.value = hp
	health_timer.start(1.0)  # Resetăm timer-ul la fiecare adăugare de viață

func _on_subtract_health_pressed():
	hp -= 1
	health_bar.value = hp
	#flash_animation.play("flash")  # Play flash effect

func _on_health_timer_timeout():
	# Dacă viața este mai mare de 0, o scădem
	if hp > 0:
		hp -= 0.05
		health_bar.value = hp
		#flash_animation.play("flash")  # Flash când se scade viața

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
