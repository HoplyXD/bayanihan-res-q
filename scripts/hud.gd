## HUD — Group 4: Inventory UI
## Manages all on-screen UI: demand display, score, durability,
## fuel bar, inventory slots, dump-cargo button, start/game-over panels.
extends CanvasLayer

# ── Top HUD ──────────────────────────────────────────────────────────────
@onready var score_label:     Label       = $ScoreLabel
@onready var level_label:     Label       = $LevelLabel
@onready var combo_label:     Label       = $ComboLabel
@onready var demand_slots: Array[Label]   = [
	$DemandContainer/Demand1 as Label,
	$DemandContainer/Demand2 as Label,
	$DemandContainer/Demand3 as Label,
]
@onready var durability_bar:  ProgressBar = $DurabilityBar
@onready var fuel_bar:        ProgressBar = $FuelBar

# ── Bottom HUD ───────────────────────────────────────────────────────────
@onready var inv_slots: Array[Label] = [
	$InventoryContainer/Slot1 as Label,
	$InventoryContainer/Slot2 as Label,
	$InventoryContainer/Slot3 as Label,
]
@onready var dump_button:   Button = $DumpButton
@onready var pause_button: Button = $PauseButton
@onready var shield_label:  Label  = $ShieldLabel

# ── Overlays ─────────────────────────────────────────────────────────────
@onready var banner_label:  Label     = $BannerLabel
@onready var hit_flash:     ColorRect = $HitFlash

# ── Panels ───────────────────────────────────────────────────────────────
@onready var start_panel:       Control = $StartPanel
@onready var start_button:      Button  = $StartPanel/StartButton
@onready var game_over_panel:   Control = $GameOverPanel
@onready var reason_label:      Label   = $GameOverPanel/ReasonLabel
@onready var final_score_label: Label   = $GameOverPanel/FinalScoreLabel
@onready var high_score_label:  Label   = $GameOverPanel/HighScoreLabel
@onready var restart_button:    Button  = $GameOverPanel/RestartButton

const RESOURCE_COLORS: Dictionary = {
	"RICE":  Color(1.00, 0.88, 0.18),
	"WATER": Color(0.18, 0.55, 1.00),
	"MEDS":  Color(1.00, 0.22, 0.22),
}

var _fuel_pulse_tween: Tween = null


func _ready() -> void:
	GameManager.score_changed.connect(_on_score_changed)
	GameManager.durability_changed.connect(_on_durability_changed)
	GameManager.fuel_changed.connect(_on_fuel_changed)
	GameManager.inventory_changed.connect(_on_inventory_changed)
	GameManager.game_over.connect(_on_game_over)
	GameManager.powerup_collected.connect(_on_powerup_collected)
	GameManager.demand_updated.connect(_on_demand_updated)
	GameManager.level_up.connect(_on_level_up)
	GameManager.combo_changed.connect(_on_combo_changed)
	GameManager.block_hit.connect(_on_block_hit_flash)
	GameManager.demand_fulfilled.connect(_on_demand_fulfilled)

	start_button.pressed.connect(_on_start_pressed)
	dump_button.pressed.connect(GameManager.dump_cargo)
	pause_button.pressed.connect(GameManager.pause)
	restart_button.pressed.connect(_on_restart_pressed)

	game_over_panel.visible = false
	shield_label.visible    = false
	banner_label.visible    = false
	combo_label.visible     = false
	start_panel.visible     = true
	_refresh_inventory([])
	_on_demand_updated([])


# ---------------------------------------------------------------------------
# Signal handlers
# ---------------------------------------------------------------------------
func _on_score_changed(val: int) -> void:
	score_label.text = "Score: %d" % val


func _on_durability_changed(val: int) -> void:
	durability_bar.value = val
	var tw := create_tween()
	tw.tween_property(durability_bar, "modulate", Color(1.8, 0.3, 0.3), 0.07)
	tw.tween_property(durability_bar, "modulate", Color.WHITE, 0.4)


func _on_fuel_changed(val: float) -> void:
	fuel_bar.value = val
	if val < 25.0:
		if _fuel_pulse_tween == null or not _fuel_pulse_tween.is_running():
			_fuel_pulse_tween = create_tween().set_loops()
			_fuel_pulse_tween.tween_property(fuel_bar, "modulate", Color(1.0, 0.1, 0.1), 0.35)
			_fuel_pulse_tween.tween_property(fuel_bar, "modulate", Color(1.0, 0.65, 0.65), 0.35)
	else:
		if _fuel_pulse_tween:
			_fuel_pulse_tween.kill()
			_fuel_pulse_tween = null
		fuel_bar.modulate = Color.WHITE


func _on_inventory_changed(inv: Array) -> void:
	_refresh_inventory(inv)


func _on_demand_updated(demand: Array) -> void:
	for i in demand_slots.size():
		var slot: Label = demand_slots[i]
		if i < demand.size():
			slot.text    = demand[i]
			slot.visible = true
			slot.add_theme_color_override("font_color",
					RESOURCE_COLORS.get(demand[i], Color.WHITE))
		else:
			slot.text    = ""
			slot.visible = false


func _on_powerup_collected(type: String) -> void:
	match type:
		"SHIELD":
			shield_label.text    = "🛡  SHIELD ACTIVE"
			shield_label.visible = true
		"SPEED_BOOST":
			shield_label.text    = "⚡ SPEED BOOST!"
			shield_label.visible = true
			await get_tree().create_timer(2.0).timeout
			shield_label.visible = false
		"REPAIR_KIT":
			_show_banner("🩵 REPAIRED!", Color(0.10, 0.88, 0.85))


func _on_level_up(lvl: int) -> void:
	level_label.text = "LVL %d" % lvl
	if lvl > 1:
		_show_banner("⬆ LEVEL %d" % lvl, Color(0.6, 1.0, 0.6))


func _on_combo_changed(combo: int) -> void:
	if combo >= 2:
		var heat: float = clampf((combo - 2) / 3.0, 0.0, 1.0)
		combo_label.add_theme_color_override("font_color",
				Color(1.0, 0.85 - heat * 0.5, 0.1))
		combo_label.text    = "x%d COMBO!" % combo
		combo_label.visible = true
	else:
		combo_label.visible = false


func _on_demand_fulfilled(_id: int) -> void:
	_show_banner("✅ DELIVERED! +100", Color(1.0, 0.88, 0.2))


func _on_block_hit_flash() -> void:
	var tw := create_tween()
	tw.tween_property(hit_flash, "color:a", 0.40, 0.06)
	tw.tween_property(hit_flash, "color:a", 0.0,  0.40)


func _on_game_over(reason: String) -> void:
	final_score_label.text = "Score: %d" % GameManager.score
	high_score_label.text  = "Best: %d"  % GameManager.high_score
	match reason:
		"TRUCK_BREAKDOWN":
			reason_label.text = "TRUCK BREAKDOWN!\nYou hit too many obstacles."
		"OUT_OF_FUEL":
			reason_label.text = "OUT OF FUEL!\nPick up fuel canisters next time."
		_:
			reason_label.text = "MISSION FAILED."
	game_over_panel.visible = true


# ---------------------------------------------------------------------------
# Button handlers
# ---------------------------------------------------------------------------
func _on_start_pressed() -> void:
	start_panel.visible = false
	GameManager.start_game()


func _on_restart_pressed() -> void:
	get_tree().reload_current_scene()


# ---------------------------------------------------------------------------
# Helpers
# ---------------------------------------------------------------------------
func _refresh_inventory(inv: Array) -> void:
	for i in inv_slots.size():
		var slot: Label = inv_slots[i]
		if i < inv.size():
			slot.text = inv[i]
			slot.add_theme_color_override("font_color",
					RESOURCE_COLORS.get(inv[i], Color.WHITE))
			slot.modulate = Color(1, 1, 1, 1)
		else:
			slot.text = "[ ]"
			slot.remove_theme_color_override("font_color")
			slot.modulate = Color(0.5, 0.5, 0.5, 1)

	shield_label.visible = GameManager.has_shield


func _show_banner(text: String, color: Color = Color.WHITE) -> void:
	banner_label.text    = text
	banner_label.modulate = Color(color.r, color.g, color.b, 0.0)
	banner_label.visible = true
	var tw := create_tween()
	tw.tween_property(banner_label, "modulate:a", 1.0, 0.25)
	tw.tween_interval(1.4)
	tw.tween_property(banner_label, "modulate:a", 0.0, 0.45)
	tw.tween_callback(func() -> void: banner_label.visible = false)
