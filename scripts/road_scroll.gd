## Road Scroll — Group 2: Map & Intel
## Moves two road panels AND the two background panels in tandem
## for infinite downward scrolling.
##
## Wrap logic (panel height = ROAD_H = 2016):
##   When RoadA scrolls off the bottom (y >= ROAD_H) →
##       RoadA jumps to RoadB.y - ROAD_H   (places it above RoadB)
##   When RoadB scrolls off the bottom (y >= ROAD_H) →
##       RoadB jumps to RoadA.y - ROAD_H   (places it above RoadA)
##
## This is equivalent to: "when RoadB reaches 0, send RoadA to -2016,
## then when RoadA reaches 0, send RoadB to -2016."

extends Node2D

const ROAD_H: float = 2016.0

# Road geometry panels (children of this node, defined in main.tscn)
@onready var road_a: Node2D = $RoadA
@onready var road_b: Node2D = $RoadB

# Background panels (children of the Background instance, sibling of this node)
var bg_a: Node2D = null
var bg_b: Node2D = null


func _ready() -> void:
	# Initialise road panels
	road_a.position.y = 0.0
	road_b.position.y = -ROAD_H

	# Grab background panels from the Background scene
	var bg: Node = get_parent().get_node_or_null("Background")
	if bg:
		bg_a = bg.get_node_or_null("RoadA")
		bg_b = bg.get_node_or_null("RoadB")
	else:
		push_warning("RoadScroll: could not find Background node in parent.")


func _process(delta: float) -> void:
	if not GameManager.game_running:
		return

	var spd: float = GameManager.game_speed

	# ── Move both road panels ──────────────────────────────────────────────
	road_a.position.y += spd * delta
	road_b.position.y += spd * delta

	# ── Move both background panels ────────────────────────────────────────
	if bg_a:
		bg_a.position.y += spd * delta
	if bg_b:
		bg_b.position.y += spd * delta

	# ── Wrap road panels ───────────────────────────────────────────────────
	# When RoadA scrolls off the bottom, place it above RoadB
	if road_a.position.y >= ROAD_H:
		road_a.position.y = road_b.position.y - ROAD_H
	# When RoadB scrolls off the bottom, place it above RoadA
	if road_b.position.y >= ROAD_H:
		road_b.position.y = road_a.position.y - ROAD_H

	# ── Wrap background panels (same logic) ────────────────────────────────
	if bg_a and bg_a.position.y >= ROAD_H:
		bg_a.position.y = bg_b.position.y - ROAD_H
	if bg_b and bg_b.position.y >= ROAD_H:
		bg_b.position.y = bg_a.position.y - ROAD_H
