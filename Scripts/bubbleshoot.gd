extends Area2D

@export var speed: float = 600.0
var direction: Vector2 = Vector2.UP

func _ready():
	# Option A:
	connect("body_entered", Callable(self, "_on_body_entered"))
	
	# Option B (if your node is indeed an Area2D with a built-in signal):
	# body_entered.connect(_on_body_entered)

func set_direction(new_direction: Vector2) -> void:
	if new_direction.length() == 0:
		direction = Vector2.UP
	else:
		direction = new_direction.normalized()

func _physics_process(delta: float) -> void:
	position += direction * speed * delta
	if position.x > 2000:
		queue_free()

func _on_body_entered(body: Node) -> void:
	if body is Fish1 or body is Fish2 or body is Fish3 or body is Fish4 or body is Fish5:
		body.take_damage(1)
		queue_free()
