## Spawner — Group 3: Events Team
## Instantiates road items in random lanes with weighted rarity.
## Speed and spawn-rate increase over time for escalating difficulty.
extends Node2D

const LANE_POSITIONS: Array[float] = [270.0, 540.0, 810.0]
const SPAWN_Y: float = -110.0

const SPAWN_INTERVAL_START: float = 1.20
const SPAWN_INTERVAL_MIN:   float = 0.45
const INTERVAL_DECREASE:    float = 0.04
const DIFFICULTY_TICK:      float = 12.0

# Spawn weights aligned to ItemBase.ItemType enum order:
# [RICE, WATER, MEDS, HAZARD, BLOCK, SHIELD, SPEED_BOOST, FUEL, REPAIR]
var _spawn_weights: Array[int] = [22, 18, 12, 16, 8, 3, 3, 12, 6]

var _item_scene: PackedScene = preload("res://scenes/items/item.tscn")

var _spawn_timer: float    = 0.0
var _diff_timer: float     = 0.0
var _spawn_interval: float = SPAWN_INTERVAL_START


func _ready() -> void:
	GameManager.level_up.connect(_on_level_up)


func _process(delta: float) -> void:
	if not GameManager.game_running:
		return

	_spawn_timer += delta
	_diff_timer  += delta

	if _spawn_timer >= _spawn_interval:
		_spawn_timer = 0.0
		_spawn_item()

	if _diff_timer >= DIFFICULTY_TICK:
		_diff_timer = 0.0
		GameManager.increase_speed()
		_spawn_interval = max(_spawn_interval - INTERVAL_DECREASE, SPAWN_INTERVAL_MIN)


func _spawn_item() -> void:
	var lane: int      = randi() % 3
	var type_idx: int  = _weighted_random()

	var item: ItemBase = _item_scene.instantiate() as ItemBase
	item.item_type = type_idx as ItemBase.ItemType
	item.position  = Vector2(LANE_POSITIONS[lane], SPAWN_Y)
	add_child(item)


func _weighted_random() -> int:
	var total: int = 0
	for w in _spawn_weights:
		total += w
	var roll: int = randi() % total
	var cumulative: int = 0
	for i in _spawn_weights.size():
		cumulative += _spawn_weights[i]
		if roll < cumulative:
			return i
	return 0


func _on_level_up(lvl: int) -> void:
	if lvl <= 1:
		return
	# Ramp up danger each level; resources diminish slightly
	_spawn_weights[3] = min(_spawn_weights[3] + 2, 26)   # HAZARD
	_spawn_weights[4] = min(_spawn_weights[4] + 1, 14)   # BLOCK
	_spawn_weights[0] = max(_spawn_weights[0] - 2, 10)   # RICE
	_spawn_weights[1] = max(_spawn_weights[1] - 1, 10)   # WATER
