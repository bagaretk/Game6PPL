extends CharacterBody2D

#@onready var flash_animation = $FlashAnimation
@onready var health_bar = $Camera2D/LayerBar/HealthBar
@onready var health_timer = $HealthTimer # Referință la Timer-ul pentru scăderea vieții

const SPEED = 300.0
const LIMIT_LEFT = -10000.0
const LIMIT_RIGHT = 10000.0
const LIMIT_TOP = -500000.0
const LIMIT_BOTTOM = 800.0

var max_hp = 100
var hp = max_hp

# Optional: scale factor at full HP is 1.0. 
# When hp is half, player is half size, etc.
# Adjust these as you prefer.
func _ready():
	health_bar.value = hp
	health_bar.max_value = max_hp
	_update_scale()
	#$CollisionShape2D.connect("area_entered", Callable(self, "_on_area_2d_body_entered"))
	

func set_health(value: float) -> void:
	hp = clamp(value, 0, max_hp)
	health_bar.value = hp
	_update_scale()
	if hp <= 0:
		get_tree().change_scene_to_file("res://youdied.tscn")

func _update_scale():
	# Example: scale between 0.1 (min) and 1.0 (max)
	# or simply scale = Vector2(hp / max_hp, hp / max_hp) if you prefer
	var ratio = float(hp) / float(max_hp)
	scale = Vector2.ONE * ratio
	# Alternatively, clamp ratio so it never goes below a certain threshold:
	# ratio = max(0.2, ratio)
	# scale = Vector2.ONE * ratio

func _physics_process(delta: float) -> void:
	var direction_x := Input.get_axis("ui_left", "ui_right")
	var direction_y := Input.get_axis("ui_up", "ui_down")

	velocity.x = direction_x * SPEED
	velocity.y = direction_y * SPEED

	move_and_slide()

	# Limit the player's position
	global_position.x = clamp(global_position.x, LIMIT_LEFT, LIMIT_RIGHT)
	global_position.y = clamp(global_position.y, LIMIT_TOP, LIMIT_BOTTOM)

	move_and_slide()

	# Handle shooting
	if Input.is_action_just_pressed("shoot"):  # Ensure you have an InputMap action named "shoot"
		_shoot_bubble()

func _shoot_bubble():
	var shoot_audio = $ShootAudio
	# Each time the player shoots, -5 HP
	set_health(hp - 5)
	if shoot_audio:
		shoot_audio.play()

	# Instance the mini-bubble (projectile) scene and add it to the tree
	var bubble = preload("res://bubbleshoot.tscn").instantiate()
	bubble.position = global_position  # spawn from player's position
	bubble.set_direction(velocity)
	get_parent().add_child(bubble)
	


func _on_area_2d_body_entered(body: Node) -> void:
	if body.is_in_group("Fish") || body.is_in_group("Health"): 
		var damage_audio = $DamageAudio
		var collect_audio = $CollectAudio
		if body.is_in_group("Fish"):
			if damage_audio:
				damage_audio.play()
			if body is Fish1:
				set_health(hp - 20)
				body.queue_free()
			elif body is Fish2:
				set_health(hp - 10)
				body.queue_free()
			elif body is Fish3:
				set_health(hp - 10)
				body.queue_free()
			elif body is Fish4:
				set_health(hp - 30)
				body.queue_free()
			elif body is Fish5:
				set_health(hp - 30)
				body.queue_free()
		elif body is HealthBubble:
			set_health(hp + 5)
		body.queue_free()



func _on_touch_screen_button_pressed() -> void:
	_shoot_bubble()
