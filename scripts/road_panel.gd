## Road Panel — single tile of road, drawn entirely in code.
## Two of these alternate (RoadA / RoadB) for infinite scrolling.
extends Node2D

# Road geometry (matches lane centres 270 / 540 / 810)
const ROAD_LEFT:  float = 135.0
const ROAD_RIGHT: float = 945.0
const W: float = 1080.0
const H: float = 1920.0

# Lane divider X positions
const DIV1: float = 405.0
const DIV2: float = 675.0

# Stripe parameters (dashed centre lines)
const STRIPE_H: float   = 80.0
const STRIPE_GAP: float = 60.0
const STRIPE_W: float   = 6.0


#func _draw() -> void:
	# ── Grass / shoulders ─────────────────────────────────────────────────
	#draw_rect(Rect2(0, 0, W, H), Color(0.16, 0.48, 0.10))

	# ── Road surface ──────────────────────────────────────────────────────
	#draw_rect(Rect2(ROAD_LEFT, 0, ROAD_RIGHT - ROAD_LEFT, H), Color(0.22, 0.22, 0.22))

	# ── Road edge lines (solid yellow) ────────────────────────────────────
	#draw_rect(Rect2(ROAD_LEFT, 0, 7, H), Color(0.95, 0.82, 0.08))
	#draw_rect(Rect2(ROAD_RIGHT - 7, 0, 7, H), Color(0.95, 0.82, 0.08))

	# ── Lane dividers (dashed white) ──────────────────────────────────────
	#var y: float = 0.0
	#while y < H:
	#	draw_rect(Rect2(DIV1 - STRIPE_W * 0.5, y, STRIPE_W, STRIPE_H), Color(0.9, 0.9, 0.9, 0.7))
	#	draw_rect(Rect2(DIV2 - STRIPE_W * 0.5, y, STRIPE_W, STRIPE_H), Color(0.9, 0.9, 0.9, 0.7))
	#	y += STRIPE_H + STRIPE_GAP
