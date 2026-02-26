extends Node

const SFX_POOL_SIZE: int = 16

var _sfx_pool: Array[AudioStreamPlayer] = []
var _next_sfx: int = 0
var _music_player: AudioStreamPlayer

var _music_main: AudioStream = preload("res://assets/audio/bossa_breeze_cafe.wav")
var _sfx_tins_enter: AudioStream = preload("res://assets/audio/ui_pop_up.mp3")
var _sfx_soft_pop: AudioStream = preload("res://assets/audio/soft_pop.wav")
var _sfx_soft_click: AudioStream = preload("res://assets/audio/soft_click.wav")
var _sfx_swipe: AudioStream = preload("res://assets/audio/swipe.wav")
var _sfx_unwrap: AudioStream = preload("res://assets/audio/paper_unwrap.wav")
var _sfx_reveal: AudioStream = preload("res://assets/audio/marimba_bloop.wav")

func _ready() -> void:
	_music_player = AudioStreamPlayer.new()
	_music_player.bus = "Music"
	add_child(_music_player)
	
	for i in SFX_POOL_SIZE:
		var player: AudioStreamPlayer = AudioStreamPlayer.new()
		player.bus = "SFX"
		add_child(player)
		_sfx_pool.append(player)
	
	play_music(_music_main)

func play_music(audio: AudioStream, volume: float = -20.0) -> void:
	_music_player.stream = audio
	_music_player.volume_db = volume
	_music_player.play()

func play_sfx(audio: AudioStream, pitch_range: float = 0.0, volume: float = 0.0) -> void:
	var player: AudioStreamPlayer = _sfx_pool[_next_sfx]
	_next_sfx = (_next_sfx + 1) % SFX_POOL_SIZE
	
	player.stream = audio
	player.volume_db = volume
	player.pitch_scale = 1.0 if pitch_range == 0.0 else randf_range(1.0 - pitch_range, 1.0 + pitch_range)
	player.play()

func play_tins_enter() -> void:
	play_sfx(_sfx_tins_enter, 0.1, -20.0)

func play_unwrap() -> void:
	play_sfx(_sfx_unwrap, 0.1, -5.0)

func play_reveal() -> void:
	play_sfx(_sfx_reveal, 0.1, -10.0)
	play_sfx(_sfx_soft_pop, 0.2, -5.0)

func play_soft_pop() -> void:
	play_sfx(_sfx_soft_pop, 0.2)

func play_soft_click() -> void:
	play_sfx(_sfx_soft_click, 0.1, -2.0)

func play_swipe() -> void:
	await get_tree().create_timer(0.05).timeout
	play_sfx(_sfx_swipe, 0.1)
