extends Node2D

# Existing enemies
@onready var Enemy1 = preload("res://enemy1.tscn")
@onready var Enemy2 = preload("res://enemy2.tscn")
@onready var Enemy3 = preload("res://enemy3.tscn")

# Now just preload Enemy4 without adding it to the probability system
@onready var Enemy4 = preload("res://healthbubble.tscn")

@export var spawn_interval: float = 3.0
@export var spawn_offset_x: float = 100.0
@export var spawn_area_top: float = 0.0
@export var spawn_area_bottom: float = 600.0
@export var spawn_margin: float = 100.0  # Distance outside the camera's view to spawn enemies

# Probabilities for the first three enemies
@export var prob_enemy1: float = 0.1
@export var prob_enemy2: float = 0.2
@export var prob_enemy3: float = 0.3

# Interval for spawning Enemy4 specifically
@export var enemy4_spawn_interval: float = 1.0

var _timer: Timer
var _timer_enemy4: Timer  # New timer for Enemy4

func _ready() -> void:
	randomize()

	# 1) Timer for Enemy1, 2, 3
	_timer = Timer.new()
	_timer.wait_time = spawn_interval
	_timer.autostart = true
	_timer.timeout.connect(_on_SpawnTimer_timeout)
	add_child(_timer)

	# 2) Timer for Enemy4
	_timer_enemy4 = Timer.new()
	_timer_enemy4.wait_time = enemy4_spawn_interval
	_timer_enemy4.autostart = true
	_timer_enemy4.timeout.connect(_on_SpawnEnemy4_timeout)
	add_child(_timer_enemy4)

	# Generate a first wave of enemies immediately
	_on_SpawnTimer_timeout()  # Generate enemies 1, 2, 3
	_on_SpawnEnemy4_timeout()  # Generate enemy 4

func _on_SpawnTimer_timeout() -> void:
	# Probability-based spawn for the first three enemies
	var random_pick = randf()
	var sum_probs = prob_enemy1 + prob_enemy2 + prob_enemy3
	var normalized_pick = random_pick * sum_probs

	if normalized_pick <= prob_enemy1:
		_spawn_enemy(Enemy1)
	elif normalized_pick <= prob_enemy1 + prob_enemy2:
		_spawn_enemy(Enemy2)
	else:
		_spawn_enemy(Enemy3)

# Called by the second timer to spawn Enemy4
func _on_SpawnEnemy4_timeout() -> void:
	# Spawn Enemy4 relative to the camera
	_spawn_enemy(Enemy4, true)  # Pass true to indicate it's Enemy4

func _spawn_enemy(enemy_scene: PackedScene, is_enemy4: bool = false) -> void:
	var enemy_instance = enemy_scene.instantiate() as CharacterBody2D
	var screen_width = get_viewport().size.x
	var screen_height = get_viewport().size.y
	var enemy_width = enemy_instance.get_node_or_null("Sprite2D").texture.get_size().x
	var enemy_height = enemy_instance.get_node_or_null("Sprite2D").texture.get_size().y

	var spawn_x: float
	var spawn_y: float

	if is_enemy4:
		# Spawn below the camera's view, ensuring it's within the visible screen
		spawn_x = randf_range(0 + enemy_width / 2, screen_width - enemy_width / 2)  # Avoids crossing left or right
		spawn_y = screen_height + spawn_margin + enemy_height / 2  # Avoids crossing bottom
		enemy_instance.position = Vector2(spawn_x, spawn_y)
	else:
		# Default spawn logic for Enemies 1, 2, 3 relative to screen size
		var from_side = randf()
		if from_side < 0.5:
			# Spawn from the left
			spawn_x = -enemy_width / 2 - spawn_margin  # Ensure enemy is within the left border
			spawn_y = randf_range(0 + enemy_height / 2, screen_height - enemy_height / 2)  # Avoids crossing top or bottom
		else:
			# Spawn from the right
			spawn_x = screen_width + enemy_width / 2 + spawn_margin  # Ensure enemy is within the right border
			spawn_y = randf_range(0 + enemy_height / 2, screen_height - enemy_height / 2)  # Avoids crossing top or bottom
		
		enemy_instance.position = Vector2(spawn_x, spawn_y)

		# If spawning from the left, invert the speed
		if from_side < 0.5:
			enemy_instance.speed *= -1
			var sprite = enemy_instance.get_node_or_null("Sprite2D")
			if sprite:
				sprite.flip_h = true
		else:
			var sprite = enemy_instance.get_node_or_null("Sprite2D")
			if sprite:
				sprite.flip_h = false

	get_parent().add_child(enemy_instance)
