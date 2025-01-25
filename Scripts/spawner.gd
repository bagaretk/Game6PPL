# Spawner.gd
extends Node2D

# Existing enemies
@onready var Enemy1 = preload("res://enemy1.tscn")
@onready var Enemy2 = preload("res://enemy2.tscn")
@onready var Enemy3 = preload("res://enemy3.tscn")
@onready var Enemy4 = preload("res://enemy4.tscn")
@onready var Enemy5 = preload("res://enemy5.tscn")

# Now just preload Enemy4 without adding it to the probability system
@onready var Bubble = preload("res://healthbubble.tscn")

@export var spawn_interval: float = 0.5
@export var spawn_offset_x: float = 100.0
@export var spawn_area_top: float = 0.0
@export var spawn_area_bottom: float = 900.0
@export var spawn_margin: float = 100.0  # Distance outside the camera's view to spawn enemies

# Probabilities for the first three enemies
@export var prob_enemy1: float = 0.1
@export var prob_enemy2: float = 0.3
@export var prob_enemy3: float = 0.6
@export var prob_enemy4: float = 0.6
@export var prob_enemy5: float = 0.6

# Interval for spawning Enemy4 specifically
@export var bubble_spawn_interval: float = 5.0

var _timer: Timer
var _timer_bubble: Timer  # New timer for Enemy4
var camera: Camera2D  # Reference to the active camera

func _ready() -> void:
	randomize()

	# Reference the active Camera2D node
	camera = get_viewport().get_camera_2d()
	if not camera:
		push_error("No Camera2D found in the viewport.")
		return

	# 1) Timer for Enemy1, 2, 3
	_timer = Timer.new()
	_timer.wait_time = spawn_interval
	_timer.autostart = true
	_timer.timeout.connect(_on_SpawnTimer_timeout)
	add_child(_timer)

	# 2) Timer for Enemy4
	_timer_bubble = Timer.new()
	_timer_bubble.wait_time = bubble_spawn_interval
	_timer_bubble.autostart = true
	_timer_bubble.timeout.connect(_on_SpawnBubble_timeout)
	add_child(_timer_bubble)

func get_camera_visible_rect() -> Rect2:
	var viewport_size_i = get_viewport().size  # Vector2i
	var viewport_size = Vector2(viewport_size_i.x, viewport_size_i.y)  # Convert to Vector2
	var zoom = camera.zoom
	var half_size = (viewport_size / zoom) / 2
	var camera_center = camera.global_position
	return Rect2(camera_center - half_size, viewport_size / zoom)

func _on_SpawnTimer_timeout() -> void:
	# Probability-based spawn for the first three enemies
	var random_pick = randf()
	var sum_probs = prob_enemy1 + prob_enemy2 + prob_enemy3 + prob_enemy4 + prob_enemy5
	var normalized_pick = random_pick * sum_probs

	if normalized_pick <= prob_enemy1:
		_spawn_enemy(Enemy1)
	elif normalized_pick <= prob_enemy1 + prob_enemy2:
		_spawn_enemy(Enemy2)
	elif normalized_pick <= prob_enemy1 + prob_enemy2 + prob_enemy3:
		_spawn_enemy(Enemy3)
	elif normalized_pick <= prob_enemy1 + prob_enemy2 + prob_enemy3 + prob_enemy4:
		_spawn_enemy(Enemy4)
	else:
		_spawn_enemy(Enemy5)

# Called by the second timer to spawn Enemy4
func _on_SpawnBubble_timeout() -> void:
	# Spawn Enemy4 relative to the camera
	_spawn_enemy(Enemy4, true)  # Pass true to indicate it's Enemy4

func _spawn_enemy(enemy_scene: PackedScene, is_enemy4: bool = false) -> void:
	var enemy_instance = enemy_scene.instantiate() as CharacterBody2D
	var camera_rect = get_camera_visible_rect()
	var screen_width = camera_rect.size.x
	var screen_height = camera_rect.size.y
	var camera_position = camera.global_position

	var spawn_x: float
	var spawn_y: float

	if is_enemy4:
		# Spawn below the camera's view
		spawn_x = randf_range(camera_rect.position.x, camera_rect.position.x + screen_width)
		spawn_y = camera_rect.position.y + screen_height + spawn_margin
		enemy_instance.position = Vector2(spawn_x, spawn_y)
	else:
		# Default spawn logic for Enemies 1, 2, 3 relative to camera
		var from_side = randf()
		if from_side < 0.5:
			# Spawn from the left
			spawn_x = camera_rect.position.x - spawn_offset_x - spawn_margin
			spawn_y = randf_range(camera_rect.position.y, camera_rect.position.y + screen_height)
		else:
			# Spawn from the right
			spawn_x = camera_rect.position.x + screen_width + spawn_offset_x + spawn_margin
			spawn_y = randf_range(camera_rect.position.y, camera_rect.position.y + screen_height)
		
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
				
	var random_scale = randf_range(0.6, 1.5)  # Adjust scale between 0.5x and 1.5x
	enemy_instance.scale = Vector2(random_scale, random_scale)	

	get_parent().add_child(enemy_instance)
