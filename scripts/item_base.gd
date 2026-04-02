## ItemBase — base class for every road item (resource, hazard, block,
## powerup, fuel).  Visuals drawn via _draw(); no child nodes required.
class_name ItemBase
extends Area2D

# ---------------------------------------------------------------------------
# Item type enum
# ---------------------------------------------------------------------------
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

# Guard against double-collection
var collected: bool = false

const ITEM_COLORS: Dictionary = {
	ItemType.RESOURCE_RICE:   Color(1.00, 0.88, 0.18),
	ItemType.RESOURCE_WATER:  Color(0.18, 0.55, 1.00),
	ItemType.RESOURCE_MEDS:   Color(1.00, 0.22, 0.22),
	ItemType.HAZARD:          Color(0.38, 0.62, 0.95, 0.85),
	ItemType.BLOCK:           Color(0.40, 0.35, 0.28),
	ItemType.POWERUP_SHIELD:  Color(0.10, 0.95, 0.45),
	ItemType.POWERUP_SPEED:   Color(1.00, 0.48, 0.05),
	ItemType.FUEL:            Color(0.80, 0.18, 0.85),
	ItemType.POWERUP_REPAIR:  Color(0.10, 0.88, 0.85),   # cyan
}

const ITEM_LABELS: Dictionary = {
	ItemType.RESOURCE_RICE:   "RICE",
	ItemType.RESOURCE_WATER:  "WATER",
	ItemType.RESOURCE_MEDS:   "MEDS",
	ItemType.HAZARD:          "FLOOD",
	ItemType.BLOCK:           "DEBRIS",
	ItemType.POWERUP_SHIELD:  "SHIELD",
	ItemType.POWERUP_SPEED:   "BOOST",
	ItemType.FUEL:            "FUEL",
	ItemType.POWERUP_REPAIR:  "REPAIR",
}


func _ready() -> void:
	collision_layer = 2
	collision_mask  = 0
	monitorable     = true
	monitoring      = false
	queue_redraw()


func _process(delta: float) -> void:
	if not GameManager.game_running:
		return
	position.y += GameManager.game_speed * delta
	if position.y > 2050.0:
		queue_free()


# ---------------------------------------------------------------------------
# Collection callback — called by player's PickupArea signal
# ---------------------------------------------------------------------------
func on_collected(player: Node) -> void:
	if collected:
		return
	collected = true

	match item_type:
		ItemType.RESOURCE_RICE:
			GameManager.collect_resource("RICE")
		ItemType.RESOURCE_WATER:
			GameManager.collect_resource("WATER")
		ItemType.RESOURCE_MEDS:
			GameManager.collect_resource("MEDS")
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


# ---------------------------------------------------------------------------
# Drawing — prototype shapes
# ---------------------------------------------------------------------------
func _draw() -> void:
	var col: Color  = ITEM_COLORS.get(item_type, Color.WHITE)
	var lbl: String = ITEM_LABELS.get(item_type, "?")

	match item_type:
		ItemType.HAZARD:
			# Watery ellipse (two overlapping circles)
			draw_circle(Vector2(0, 5),   46.0, col)
			draw_circle(Vector2(0, -5),  38.0, col.lightened(0.2))
			draw_circle(Vector2(0, 0),   22.0, Color(0.5, 0.7, 1.0, 0.6))

		ItemType.BLOCK:
			# Chunky debris rectangle with X
			draw_rect(Rect2(-48, -32, 96, 64), col)
			draw_rect(Rect2(-48, -32, 96, 12), col.lightened(0.15))
			draw_line(Vector2(-38, -22), Vector2(38, 22), Color(0.1, 0.1, 0.1), 6.0)
			draw_line(Vector2(38, -22),  Vector2(-38, 22), Color(0.1, 0.1, 0.1), 6.0)

		ItemType.POWERUP_SHIELD, ItemType.POWERUP_SPEED:
			# Diamond / powerup gem
			var pts := PackedVector2Array([
				Vector2(0, -52), Vector2(52, 0), Vector2(0, 52), Vector2(-52, 0)
			])
			draw_polygon(pts, PackedColorArray([col, col, col, col]))
			var inner := PackedVector2Array([
				Vector2(0, -36), Vector2(36, 0), Vector2(0, 36), Vector2(-36, 0)
			])
			var ic := col.lightened(0.4)
			draw_polygon(inner, PackedColorArray([ic, ic, ic, ic]))

		ItemType.FUEL:
			# Fuel canister shape
			draw_rect(Rect2(-22, -44, 44, 72), col)
			draw_rect(Rect2(-14, -56, 28, 16), col.darkened(0.15))
			draw_rect(Rect2(-6,  -60, 12, 8),  col.darkened(0.3))
			draw_rect(Rect2(-18, -20, 36, 6),  Color(1, 1, 1, 0.4))

		ItemType.POWERUP_REPAIR:
			# Medical cross
			draw_rect(Rect2(-46, -18, 92, 36), col)
			draw_rect(Rect2(-18, -46, 36, 92), col)
			draw_rect(Rect2(-40, -12, 80, 24), col.lightened(0.3))

		_:
			# Resources — coloured box with highlight
			draw_rect(Rect2(-42, -42, 84, 84), col)
			draw_rect(Rect2(-42, -42, 84, 18), col.lightened(0.3))
			draw_rect(Rect2(-42, -42, 8,  84), col.lightened(0.2))

	# Label text
	var font: Font = ThemeDB.fallback_font
	if font:
		var font_size: int = 20
		var text_w: float  = font.get_string_size(lbl, HORIZONTAL_ALIGNMENT_LEFT, -1, font_size).x
		draw_string(font, Vector2(-text_w * 0.5, 10), lbl,
				HORIZONTAL_ALIGNMENT_LEFT, -1, font_size, Color.WHITE)
