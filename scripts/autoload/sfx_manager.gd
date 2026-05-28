## SFXManager — Global Singleton (Autoload)
## Plays one-shot sound effects requested by callers (e.g. dialogue lines).
## Only one SFX stream plays at a time; a new request stops the previous one.
##
## USAGE (from anywhere):
##   SFXManager.play("res://path/to/sound.ogg")
##   SFXManager.stop()
extends Node

const BUS_NAME: StringName = &"Master"

var _player: AudioStreamPlayer
var _current_path: String = ""
var _cache: Dictionary = {}


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	_player = AudioStreamPlayer.new()
	_player.process_mode = Node.PROCESS_MODE_ALWAYS
	_player.bus = BUS_NAME
	add_child(_player)


## Play a sound by path. Empty / invalid paths are ignored.
## Any currently-playing SFX is stopped first.
func play(path: String) -> void:
	stop()
	if path.is_empty():
		return
	var stream: AudioStream = _load_stream(path)
	if stream == null:
		push_warning("SFXManager: could not load '%s'" % path)
		return
	_player.stream = stream
	_current_path = path
	_player.play()


## Stop any currently-playing SFX.
func stop() -> void:
	if _player and _player.playing:
		_player.stop()
	_current_path = ""


func is_playing() -> bool:
	return _player != null and _player.playing


func current_path() -> String:
	return _current_path


func _load_stream(path: String) -> AudioStream:
	if _cache.has(path):
		return _cache[path] as AudioStream
	if not ResourceLoader.exists(path):
		return null
	var res: Resource = load(path)
	if res is AudioStream:
		_cache[path] = res
		return res
	return null
