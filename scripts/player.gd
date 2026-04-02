## Player — Group 5: Fleet Group
## Handles 3-lane snapping movement, visuals drawn via _draw(),
## and item pickup via a child Area2D.
extends CharacterBody2D

const LANE_POSITIONS: Array[float] = [270.0, 540.0, 810.0]
const LANE_SWITCH_SPEED: float     = 18.0   # tween duration divisor

var current_lane: int  = 1
var target_x: float    = 540.0
var is_penalized: bool = false
var penalty_timer: float = 0.0

# Smoothing
var _tween: Tween = null


func _ready() -> void:
	position.x = LANE_POSITIONS[current_lane]
	position.y = 1650.0
	$PickupArea.area_entered.connect(_on_pickup_area_entered)
	GameManager.hazard_hit.connect(_on_hazard_hit)


func _process(delta: float) -> void:
	if not GameManager.game_running:
		return
	if is_penalized:
		penalty_timer -= delta
		if penalty_timer <= 0.0:
			is_penalized = false
			queue_redraw()


func _input(event: InputEvent) -> void:
	if not GameManager.game_running:
		return

	# ── Keyboard ──────────────────────────────────────────────────────────
	if event is InputEventKey and event.pressed and not event.echo:
		match event.physical_keycode:
			KEY_A, KEY_LEFT:   switch_lane(-1)
			KEY_D, KEY_RIGHT:  switch_lane(1)
			KEY_SPACE:         GameManager.dump_cargo()

	# ── Touch (portrait, single-handed) ───────────────────────────────────
	if event is InputEventScreenTouch and event.pressed:
		if event.position.y > 1720.0:
			GameManager.dump_cargo()
		elif event.position.x < 540.0:
			switch_lane(-1)
		else:
			switch_lane(1)


# ---------------------------------------------------------------------------
# Lane switching
# ---------------------------------------------------------------------------
func switch_lane(direction: int) -> void:
	var new_lane: int = clamp(current_lane + direction, 0, 2)
	if new_lane == current_lane:
		return
	current_lane = new_lane
	target_x = LANE_POSITIONS[current_lane]

	if _tween:
		_tween.kill()
	_tween = create_tween().set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	_tween.tween_property(self, "position:x", target_x, 0.14)


# ---------------------------------------------------------------------------
# Pickup detection
# ---------------------------------------------------------------------------
func _on_pickup_area_entered(area: Area2D) -> void:
	if area.has_method("on_collected"):
		area.on_collected(self)


# ---------------------------------------------------------------------------
# Hazard penalty
# ---------------------------------------------------------------------------
func _on_hazard_hit() -> void:
	is_penalized = true
	penalty_timer = GameManager.HAZARD_PENALTY_DURATION
	queue_redraw()


# ---------------------------------------------------------------------------
# Drawing — simple truck shape using primitives
# ---------------------------------------------------------------------------
func _draw() -> void:
	var body_color := Color(0.10, 0.35, 0.75) if not is_penalized else Color(0.85, 0.25, 0.10)

	# Truck bed (back)
	draw_rect(Rect2(-50, 0, 100, 80), body_color.darkened(0.25))
	# Cab (front / top in portrait = going upward on screen)
	draw_rect(Rect2(-50, -80, 100, 80), body_color)
	# Windshield
	draw_rect(Rect2(-35, -72, 70, 40), Color(0.65, 0.88, 1.0, 0.85))
	# Headlights
	draw_rect(Rect2(-48, -82, 18, 10), Color(1.0, 0.95, 0.5))
	draw_rect(Rect2(30, -82, 18, 10), Color(1.0, 0.95, 0.5))
	# Wheels
	for pos in [Vector2(-48, -55), Vector2(48, -55), Vector2(-48, 60), Vector2(48, 60)]:
		draw_circle(pos, 16.0, Color(0.12, 0.12, 0.12))
		draw_circle(pos, 8.0, Color(0.35, 0.35, 0.35))
	# Shield indicator
	if GameManager.has_shield:
		draw_rect(Rect2(-54, -86, 108, 170), Color(0.0, 1.0, 0.4, 0.25))
		draw_rect(Rect2(-54, -86, 108, 4), Color(0.0, 1.0, 0.4, 0.8))
		draw_rect(Rect2(-54, 80, 108, 4), Color(0.0, 1.0, 0.4, 0.8))
