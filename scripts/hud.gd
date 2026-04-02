## HUD — Group 4: Inventory UI
## Manages all on-screen UI: demand display, score, durability,
## fuel bar, inventory slots, dump-cargo button, start/game-over panels.
extends CanvasLayer

# ── Top HUD ──────────────────────────────────────────────────────────────
@onready var score_label:     Label       = $ScoreLabel
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
@onready var shield_label:  Label  = $ShieldLabel

# ── Panels ───────────────────────────────────────────────────────────────
@onready var start_panel:      Control = $StartPanel
@onready var start_button:     Button  = $StartPanel/StartButton
@onready var game_over_panel:  Control = $GameOverPanel
@onready var reason_label:     Label   = $GameOverPanel/ReasonLabel
@onready var final_score_label:Label   = $GameOverPanel/FinalScoreLabel
@onready var restart_button:   Button  = $GameOverPanel/RestartButton

const RESOURCE_COLORS: Dictionary = {
	"RICE":  Color(1.00, 0.88, 0.18),
	"WATER": Color(0.18, 0.55, 1.00),
	"MEDS":  Color(1.00, 0.22, 0.22),
}


func _ready() -> void:
	# Connect GameManager signals
	GameManager.score_changed.connect(_on_score_changed)
	GameManager.durability_changed.connect(_on_durability_changed)
	GameManager.fuel_changed.connect(_on_fuel_changed)
	GameManager.inventory_changed.connect(_on_inventory_changed)
	GameManager.game_over.connect(_on_game_over)
	GameManager.powerup_collected.connect(_on_powerup_collected)
	GameManager.demand_updated.connect(_on_demand_updated)

	# Connect buttons
	start_button.pressed.connect(_on_start_pressed)
	dump_button.pressed.connect(GameManager.dump_cargo)
	restart_button.pressed.connect(_on_restart_pressed)

	# Initial state
	game_over_panel.visible = false
	shield_label.visible    = false
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


func _on_fuel_changed(val: float) -> void:
	fuel_bar.value = val
	if val < 20.0:
		fuel_bar.modulate = Color(1.0, 0.3, 0.3)
	else:
		fuel_bar.modulate = Color(1.0, 1.0, 1.0)


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
	if type == "SHIELD":
		shield_label.text    = "🛡  SHIELD ACTIVE"
		shield_label.visible = true
	elif type == "SPEED_BOOST":
		shield_label.text    = "⚡ SPEED BOOST!"
		shield_label.visible = true
		await get_tree().create_timer(2.0).timeout
		shield_label.visible = false


func _on_game_over(reason: String) -> void:
	final_score_label.text = "Score: %d" % GameManager.score
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

	# Flash shield indicator when shield is active
	shield_label.visible = GameManager.has_shield
