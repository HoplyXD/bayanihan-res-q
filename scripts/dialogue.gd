## Dialogue — displays multi-line dialogue boxes, pauses the game,
## and resumes when all lines are dismissed.
##
## USAGE (from anywhere):
##   GameManager.play_dialogue(4)
##
## process_mode must be ALWAYS on the CanvasLayer (.tscn already set).

extends CanvasLayer

# ---------------------------------------------------------------------------
# Dialogue data
# ---------------------------------------------------------------------------
const DIALOGUES: Dictionary = {
	1: [
		{"speaker": "ResHQ", "text": "Test Text."},
		{"speaker": "ResHQ", "text": "Test Text 2"},
	],
	2: [
		{"speaker": "ResHQ", "text": "(*O*)/ WARNING!!! Hazard!!!!!."},
	]
}

# ---------------------------------------------------------------------------
# Node references  (adjust paths if your scene hierarchy differs)
# ---------------------------------------------------------------------------
@onready var name_label:     Label = $Control/VBoxContainer/NameLabel
@onready var text_label:     Label = $Control/VBoxContainer/TextLabel
@onready var continue_label: Label = $Control/VBoxContainer/ContinueLabel

# ---------------------------------------------------------------------------
# Internal state
# ---------------------------------------------------------------------------
var _lines:             Array = []
var _line_index:        int   = 0
var _active:            bool  = false
var _accept_input:      bool  = false   # one-frame delay so trigger tap doesn't skip line 0
var _was_running:       bool  = false
var _pause_menu_active: bool  = false   # true while the pause menu is open


func _ready() -> void:
	visible = false
	GameManager.dialogue_requested.connect(_on_dialogue_requested)

	# Track whether the pause menu is open so we can block dialogue clicks
	GameManager.game_paused.connect(_on_game_paused)
	GameManager.game_resumed.connect(_on_game_resumed)


# ---------------------------------------------------------------------------
# Public entry point
# ---------------------------------------------------------------------------
func _on_dialogue_requested(id: int) -> void:
	if not DIALOGUES.has(id):
		push_warning("Dialogue: no entry for id %d" % id)
		return
	if _active:
		return   # don't stack dialogues

	_lines        = DIALOGUES[id]
	_line_index   = 0
	_active       = true
	_accept_input = false
	_was_running  = GameManager.game_running

	get_tree().paused        = true
	GameManager.game_running = false

	visible = true
	_show_line()

	# Wait one frame before accepting input so the tap that opened dialogue
	# doesn't immediately advance past the first line
	await get_tree().process_frame
	_accept_input = true


# ---------------------------------------------------------------------------
# Show current line
# ---------------------------------------------------------------------------
func _show_line() -> void:
	var line = _lines[_line_index]

	if line is Dictionary:
		var speaker: String = line.get("speaker", "")
		name_label.text    = speaker
		name_label.visible = speaker != ""
		text_label.text    = line.get("text", "")
	else:
		name_label.visible = false
		text_label.text    = str(line)

	var is_last: bool = (_line_index >= _lines.size() - 1)
	continue_label.text = "▼  tap / Enter to close" if is_last else "▼  tap / Enter"


# ---------------------------------------------------------------------------
# Input — advance or close
# Only fires when dialogue is active, input is unlocked, AND pause menu
# is NOT open (so the dialogue box is frozen while pause menu is showing).
# ---------------------------------------------------------------------------
func _unhandled_input(event: InputEvent) -> void:
	if not _active or not _accept_input:
		return

	# ← KEY FIX: ignore taps/clicks while the pause menu is open
	if _pause_menu_active:
		return

	var advance: bool = false

	if event is InputEventKey and event.pressed and not event.echo:
		match event.physical_keycode:
			KEY_ENTER, KEY_KP_ENTER, KEY_SPACE:
				advance = true
			KEY_ESCAPE:
				# Forward ESC to pause system; dialogue will freeze via _on_game_paused
				get_viewport().set_input_as_handled()
				GameManager.pause()
				return

	elif event is InputEventScreenTouch and event.pressed:
		advance = true

	elif event is InputEventMouseButton and event.pressed \
			and event.button_index == MOUSE_BUTTON_LEFT:
		advance = true

	if advance:
		get_viewport().set_input_as_handled()
		_next_line()


# ---------------------------------------------------------------------------
# Pause menu opened — freeze dialogue input
# ---------------------------------------------------------------------------
func _on_game_paused() -> void:
	_pause_menu_active = true


# ---------------------------------------------------------------------------
# Pause menu closed — if dialogue is still active, re-pause the tree
# so the world stays frozen and dialogue resumes normally
# ---------------------------------------------------------------------------
func _on_game_resumed() -> void:
	_pause_menu_active = false
	if _active:
		# Pause menu handed control back but dialogue isn't done yet
		get_tree().paused        = true
		GameManager.game_running = false


# ---------------------------------------------------------------------------
# Advance lines
# ---------------------------------------------------------------------------
func _next_line() -> void:
	_line_index += 1
	if _line_index < _lines.size():
		_show_line()
	else:
		_end_dialogue()


# ---------------------------------------------------------------------------
# End: hide, unpause, resume game
# ---------------------------------------------------------------------------
func _end_dialogue() -> void:
	_active  = false
	visible  = false
	get_tree().paused = false
	if _was_running:
		GameManager.game_running = true
		GameManager.emit_signal("game_resumed")
