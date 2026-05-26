## ItemBase - base class for every road item.
class_name ItemBase
extends Area2D

enum ItemType {
	RESOURCE_RICE,
	RESOURCE_WATER,
	RESOURCE_MEDS,
	HAZARD,
	BLOCK,
	POWERUP_SHIELD,
	POWERUP_SPEED,
	FUEL,
	POWERUP_REPAIR,
}

@export var item_type: ItemType = ItemType.RESOURCE_RICE
@export var lane_index: int = 1

const EVENT_CALM: int = 0
const EVENT_TYPHOON: int = 1
const EVENT_FLOODING: int = 2
const EVENT_EARTHQUAKE: int = 3
const EVENT_VOLCANIC: int = 4

const TEXTURE_PATHS: Dictionary = {
	ItemType.RESOURCE_RICE: [
		"res://assets/Item Assets/Rice Icon (Detailed) .png",
		"res://assets/Item Assets/Rice Icon w logo 1 (Detailed) .png",
	],
	ItemType.RESOURCE_WATER: [
		"res://assets/Item Assets/water bottle icon.png",
		"res://assets/Item Assets/Water Icon (Silver-Detailed).png",
	],
	ItemType.RESOURCE_MEDS: ["res://assets/Item Assets/Medicine Icon (Detailed) .png"],
	ItemType.POWERUP_SHIELD: ["res://assets/Item Assets/shield-icon.png"],
	ItemType.POWERUP_SPEED: ["res://assets/Item Assets/speedboost-icon.png"],
	ItemType.FUEL: ["res://assets/Item Assets/FuelBar2.png"],
	ItemType.POWERUP_REPAIR: ["res://assets/Item Assets/Repair Icon .png"],
}

const HAZARD_TEXTURE_PATHS: Array[String] = [
	"res://assets/Flood & Typhoon Assets/Environment/Ground/Puddle variations/Puddles Assets1.png",
	"res://assets/Flood & Typhoon Assets/Environment/Ground/Puddle variations/Puddles Assets2.png",
	"res://assets/Flood & Typhoon Assets/Environment/Ground/Puddle variations/Puddles Assets3.png",
	"res://assets/Flood & Typhoon Assets/Environment/Ground/Puddle variations/Puddles Assets4.png",
]

const VEHICLE_ANIMATIONS: Array[StringName] = [&"Car1", &"Car2", &"Car3", &"Tricycle1", &"Tricycle2", &"Tricycle3"]

@onready var item_texture: TextureRect = $Item
@onready var default_collision: CollisionShape2D = $CollisionShape2D
@onready var mr_lane_collision: CollisionShape2D = $"MR-2LaneCollisionShape2D"
@onready var ml_lane_collision: CollisionShape2D = $"ML-2LaneCollisionShape2D"

var collected: bool = false
var _selected_texture_path: String = ""


func _ready() -> void:
	collision_layer = 2
	collision_mask = 0
	monitorable = true
	monitoring = false
	_refresh_texture()


func _process(delta: float) -> void:
	if not GameManager.game_running:
		return
	position.y += GameManager.game_speed * delta
	if position.y > 2050.0:
		queue_free()


func on_collected(player: Node) -> void:
	if collected:
		return
	collected = true

	match item_type:
		ItemType.RESOURCE_RICE:
			GameManager.collect_resource("RICE", _selected_texture_path)
		ItemType.RESOURCE_WATER:
			GameManager.collect_resource("WATER", _selected_texture_path)
		ItemType.RESOURCE_MEDS:
			GameManager.collect_resource("MEDS", _selected_texture_path)
		ItemType.HAZARD:
			GameManager.on_hazard_hit()
		ItemType.BLOCK:
			GameManager.on_block_hit()
		ItemType.POWERUP_SHIELD:
			GameManager.collect_powerup("SHIELD")
			if player.has_method("queue_redraw"):
				player.queue_redraw()
		ItemType.POWERUP_SPEED:
			GameManager.collect_powerup("SPEED_BOOST")
		ItemType.FUEL:
			GameManager.collect_fuel()
		ItemType.POWERUP_REPAIR:
			GameManager.collect_powerup("REPAIR_KIT")
			if player.has_method("queue_redraw"):
				player.queue_redraw()

	queue_free()


func _refresh_texture() -> void:
	_hide_visuals()
	_reset_collision_shapes()
	if item_type == ItemType.BLOCK:
		_show_block_variant()
	else:
		_selected_texture_path = _get_texture_path()
		item_texture.texture = load(_selected_texture_path)
		item_texture.visible = true


func _get_texture_path() -> String:
	match item_type:
		ItemType.HAZARD:
			return _pick(HAZARD_TEXTURE_PATHS)
		ItemType.BLOCK:
			return ""
		_:
			return _pick(TEXTURE_PATHS.get(item_type, TEXTURE_PATHS[ItemType.RESOURCE_RICE]))


func _show_block_variant() -> void:
	var options := _get_block_options()
	if options.is_empty():
		_show_canvas_variant($"Tree branches")
		return

	var option: Dictionary = options.pick_random()
	var node := get_node_or_null(option.get("node", ""))
	if node == null:
		return

	var collision_name: String = option.get("collision", "")
	if collision_name == "MR":
		default_collision.disabled = true
		mr_lane_collision.disabled = false
	elif collision_name == "ML":
		default_collision.disabled = true
		ml_lane_collision.disabled = false

	if node is AnimatedSprite2D:
		_show_animated_variant(node as AnimatedSprite2D, option.get("animation", &""))
	elif node is CanvasItem:
		_show_canvas_variant(node as CanvasItem)


func _get_block_options() -> Array[Dictionary]:
	var event := GameManager.current_hazard_event
	var options: Array[Dictionary] = []

	if event in [EVENT_CALM, EVENT_TYPHOON]:
		options.append({"node": "Tree branches"})
		options.append({"node": "Sprite2D"})

	for animation in VEHICLE_ANIMATIONS:
		options.append({"node": "CrackAnim", "animation": animation})

	if event in [EVENT_CALM, EVENT_EARTHQUAKE, EVENT_VOLCANIC]:
		options.append({"node": "Crack1"})
		options.append({"node": "Crack2"})
		options.append({"node": "DebrisAnim", "animation": &"Debris1"})
		options.append({"node": "DebrisAnim", "animation": &"Debris2"})

	if event in [EVENT_EARTHQUAKE, EVENT_VOLCANIC]:
		options.append({"node": "CrackAnim", "animation": &"Crack"})

	if lane_index == 2:
		if event in [EVENT_CALM, EVENT_TYPHOON, EVENT_EARTHQUAKE]:
			options.append({"node": "R-LaneTreeAnim", "animation": &"Tree1"})
			options.append({"node": "R-LaneTreeAnim", "animation": &"Tree2"})
		options.append({"node": "R-LaneDebrisAnim", "animation": &"Debris3"})
		if event != EVENT_FLOODING:
			options.append({"node": "R-LaneDebrisAnim", "animation": &"Debris4"})
	elif lane_index == 0:
		if event in [EVENT_CALM, EVENT_TYPHOON, EVENT_EARTHQUAKE]:
			options.append({"node": "L-LaneTreeAnim", "animation": &"Tree1"})
			options.append({"node": "L-LaneTreeAnim", "animation": &"Tree2"})
		options.append({"node": "L-LaneDebrisAnim", "animation": &"Debris3"})
		if event != EVENT_FLOODING:
			options.append({"node": "L-LaneDebrisAnim", "animation": &"Debris4"})
	else:
		options.append({"node": "MR-2LaneDebrisAnim", "animation": &"Debris5", "collision": "MR"})
		options.append({"node": "ML-2LaneDebrisAnim", "animation": &"Debris5", "collision": "ML"})
		if event != EVENT_FLOODING:
			options.append({"node": "MR-2LaneDebrisAnim", "animation": &"Debris6", "collision": "MR"})
			options.append({"node": "ML-2LaneDebrisAnim", "animation": &"Debris6", "collision": "ML"})

	return options


func _show_canvas_variant(node: CanvasItem) -> void:
	node.visible = true


func _show_animated_variant(node: AnimatedSprite2D, animation: StringName) -> void:
	node.visible = true
	if not animation.is_empty():
		node.animation = animation
	node.frame = 0
	node.play()


func _hide_visuals() -> void:
	for node_name in [
		"Item",
		"Crack1",
		"Crack2",
		"CrackAnim",
		"DebrisAnim",
		"R-LaneDebrisAnim",
		"L-LaneDebrisAnim",
		"MR-2LaneDebrisAnim",
		"ML-2LaneDebrisAnim",
		"R-LaneTreeAnim",
		"L-LaneTreeAnim",
		"Tree branches",
		"Sprite2D",
	]:
		var node := get_node_or_null(node_name)
		if node is CanvasItem:
			(node as CanvasItem).visible = false


func _reset_collision_shapes() -> void:
	default_collision.disabled = false
	mr_lane_collision.disabled = true
	ml_lane_collision.disabled = true


func _pick(paths: Array) -> String:
	if paths.is_empty():
		return ""
	return paths[randi() % paths.size()]
