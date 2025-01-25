extends CharacterBody2D

# Viteza de mișcare a personajului
var speed = 100
# Direcția mișcării
var direction = Vector2.ZERO

# Funcție de actualizare
func _process(delta):
	# Mișcare aleatorie la fiecare cadru
	if direction == Vector2.ZERO:
		direction = Vector2(randf_range(-1,1), randf_range(-1, 1)).normalized()

	# Calculăm mișcarea
	velocity = direction * speed

	# Mergem cu mișcarea
	move_and_slide()

	# Obținem dimensiunile ecranului
	var screen_size = get_viewport().get_visible_rect().size

	# Verificăm dacă personajul se apropie de margine și îl redirecționăm
	if position.x <= 0 or position.x > screen_size.x:
		direction.x = -direction.x  # Întoarce mișcarea pe orizontală

	if position.y <= 0 or position.y > screen_size.y:
		direction.y = -direction.y  # Întoarce mișcarea pe verticală
