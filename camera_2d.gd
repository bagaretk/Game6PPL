extends Camera2D

@onready var health_bar = $HealthBar # Asigură-te că ai adresa corectă a HealthBar
#@onready var camera = $Camera2D# Asigură-te că ai adresa corectă a HealthBar
func _ready():
	# Setează poziția inițială a health_bar-ului
	update_health_bar_position()

func _process(delta):
	# Actualizează poziția health_bar-ului în fiecare frame
	update_health_bar_position()
	print("Camera position: ", health_bar.position)
	

func update_health_bar_position():
	# Obține dimensiunea viewport-ului
	var viewport_size = get_viewport().size

	# Poziționează health_bar în colțul din stânga sus al camerei
	# Poți modifica aceste valori pentru a muta health_bar-ul mai aproape sau mai departe
	#health_bar.position = Vector2(-viewport_size.x / 2 + 20, -viewport_size.y / 2 + 20)
