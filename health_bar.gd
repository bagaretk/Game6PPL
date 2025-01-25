extends ProgressBar

@onready var flash_animation = $FlashAnimation
@onready var health_bar = $HealthBar

var hp = 10

func _ready():
	health_bar.value = hp

func _on_add_health_pressed():
	hp += 1
	health_bar.value = hp

func _on_subtract_health_pressed():
	hp -= 1
	health_bar.value = hp
	flash_animation.play("flash") # Play flash effect
