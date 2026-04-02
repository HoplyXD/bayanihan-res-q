## GameManager — Global Singleton (Autoload)
## Central hub for game state, signals, and shared logic.
## All groups communicate through this node using signals.
extends Node

# ---------------------------------------------------------------------------
# Signals (standardised interface between groups)
# ---------------------------------------------------------------------------
signal resource_collected(type: String)
signal hazard_hit
signal block_hit
signal powerup_collected(type: String)
signal fuel_collected
signal game_over(reason: String)
signal demand_fulfilled(barangay_id: int)
signal inventory_changed(inventory: Array)
signal score_changed(score: int)
signal durability_changed(durability: int)
signal fuel_changed(fuel: float)
signal speed_changed(speed: float)
signal demand_updated(demand: Array)

# ---------------------------------------------------------------------------
# Constants
# ---------------------------------------------------------------------------
const MAX_INVENTORY: int   = 3
const MAX_DURABILITY: int  = 3
const BASE_SPEED: float    = 400.0
const MAX_SPEED: float     = 900.0
const SPEED_INCREMENT: float = 20.0
const FUEL_DRAIN_RATE: float = 4.5   # units/second
const FUEL_PICKUP_AMOUNT: float = 40.0
const HAZARD_SPEED_PENALTY: float = 160.0
const HAZARD_PENALTY_DURATION: float = 2.0

const RESOURCE_TYPES: Array[String] = ["RICE", "WATER", "MEDS"]

# ---------------------------------------------------------------------------
# Runtime state
# ---------------------------------------------------------------------------
var score: int        = 0
var durability: int   = MAX_DURABILITY
var game_running: bool = false
var game_speed: float = BASE_SPEED
var fuel: float       = 100.0
var has_shield: bool  = false
var inventory: Array  = []          # Array of String
var current_demand: Array = []      # Array of String


# ---------------------------------------------------------------------------
# Lifecycle
# ---------------------------------------------------------------------------
func _ready() -> void:
	randomize()


func _process(delta: float) -> void:
	if not game_running:
		return
	_drain_fuel(delta)


# ---------------------------------------------------------------------------
# Game flow
# ---------------------------------------------------------------------------
func start_game() -> void:
	score      = 0
	durability = MAX_DURABILITY
	game_speed = BASE_SPEED
	fuel       = 100.0
	has_shield = false
	inventory.clear()
	game_running = true
	_generate_demand()
	emit_signal("score_changed",      score)
	emit_signal("durability_changed", durability)
	emit_signal("fuel_changed",       fuel)
	emit_signal("inventory_changed",  inventory)


func end_game(reason: String) -> void:
	game_running = false
	emit_signal("game_over", reason)


# ---------------------------------------------------------------------------
# Inventory & resources
# ---------------------------------------------------------------------------
func collect_resource(type: String) -> void:
	if inventory.size() >= MAX_INVENTORY:
		return
	inventory.append(type)
	add_score(10)
	emit_signal("inventory_changed", inventory)
	emit_signal("resource_collected", type)
	_check_demand_match()


func dump_cargo() -> void:
	if inventory.is_empty():
		return
	inventory.clear()
	emit_signal("inventory_changed", inventory)


# ---------------------------------------------------------------------------
# Hazards & blocks
# ---------------------------------------------------------------------------
func on_hazard_hit() -> void:
	emit_signal("hazard_hit")
	# Speed penalty applied in player.gd via signal


func on_block_hit() -> void:
	if has_shield:
		has_shield = false
		return
	durability -= 1
	emit_signal("durability_changed", durability)
	emit_signal("block_hit")
	if durability <= 0:
		end_game("TRUCK_BREAKDOWN")


# ---------------------------------------------------------------------------
# Powerups & fuel
# ---------------------------------------------------------------------------
func collect_powerup(type: String) -> void:
	match type:
		"SHIELD":
			has_shield = true
		"SPEED_BOOST":
			game_speed = min(game_speed + 120.0, MAX_SPEED)
			emit_signal("speed_changed", game_speed)
	add_score(25)
	emit_signal("powerup_collected", type)


func collect_fuel() -> void:
	fuel = min(fuel + FUEL_PICKUP_AMOUNT, 100.0)
	add_score(15)
	emit_signal("fuel_changed", fuel)
	emit_signal("fuel_collected")


# ---------------------------------------------------------------------------
# Scoring & speed
# ---------------------------------------------------------------------------
func add_score(amount: int) -> void:
	score += amount
	emit_signal("score_changed", score)


func increase_speed() -> void:
	game_speed = min(game_speed + SPEED_INCREMENT, MAX_SPEED)
	emit_signal("speed_changed", game_speed)


# ---------------------------------------------------------------------------
# Internal helpers
# ---------------------------------------------------------------------------
func _drain_fuel(delta: float) -> void:
	fuel = max(fuel - FUEL_DRAIN_RATE * delta, 0.0)
	emit_signal("fuel_changed", fuel)
	if fuel <= 0.0:
		end_game("OUT_OF_FUEL")


func _generate_demand() -> void:
	current_demand.clear()
	var count: int = randi_range(1, 3)
	for _i in count:
		current_demand.append(RESOURCE_TYPES[randi() % RESOURCE_TYPES.size()])
	emit_signal("demand_updated", current_demand)


func _check_demand_match() -> void:
	if inventory.is_empty() or current_demand.is_empty():
		return
	var remaining: Array = current_demand.duplicate()
	for item in inventory:
		remaining.erase(item)
	if remaining.is_empty():
		add_score(100)
		emit_signal("demand_fulfilled", 0)
		inventory.clear()
		emit_signal("inventory_changed", inventory)
		_generate_demand()
