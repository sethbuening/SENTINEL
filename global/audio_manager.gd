extends Node

var current_player: AudioStreamPlayer
var next_player: AudioStreamPlayer

var fade_time := 1.5

var battle_songs: Array[AudioStream] = [preload("res://music/Song 3.wav"),
										preload("res://music/15-8.wav")]

func _ready():
	current_player = AudioStreamPlayer.new()
	next_player = AudioStreamPlayer.new()

	current_player.bus = "Music"
	next_player.bus = "Music"
	
	current_player.finished.connect(func():
		play_music(battle_songs.pick_random(), true)
	)


	add_child(current_player)
	add_child(next_player)
	
	#play_music(battle_songs.pick_random(), false, false)

func play_music(stream: AudioStream, restart: bool = false, fade_in: bool = true):
	if current_player.stream == stream:
		if not restart:
			return # already playing
	
	if not fade_in:
		current_player.stop()
		current_player.stream = stream
		current_player.play()
		return

	next_player.stream = stream
	next_player.volume_db = -80
	next_player.play()

	var tween := create_tween()
	tween.set_parallel(true)

	tween.tween_property(current_player, "volume_db", -80, fade_time)
	tween.tween_property(next_player, "volume_db", 0, fade_time)

	tween.finished.connect(func():
		current_player.stop()
		
		# swap players
		var temp = current_player
		current_player = next_player
		next_player = temp
	)
