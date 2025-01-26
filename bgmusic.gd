extends Node

@export var audio_stream: AudioStream

func _ready():
	if audio_stream:
		var player = AudioStreamPlayer.new()
		add_child(player)
		player.stream = audio_stream
		player.loop = true
		player.play()
