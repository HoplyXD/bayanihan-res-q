## Road Scroll — Group 2: Map & Intel
## Moves two road panels in tandem to create an infinite downward scroll.
extends Node2D

const ROAD_H: float = 1920.0

@onready var road_a: Node2D = $RoadA
@onready var road_b: Node2D = $RoadB


func _ready() -> void:
	road_a.position.y = 0.0
	road_b.position.y = -ROAD_H


func _process(delta: float) -> void:
	if not GameManager.game_running:
		return

	var spd: float = GameManager.game_speed
	road_a.position.y += spd * delta
	road_b.position.y += spd * delta

	# Wrap: when a panel scrolls fully off the bottom, jump it above the other
	if road_a.position.y >= ROAD_H:
		road_a.position.y = road_b.position.y - ROAD_H
	if road_b.position.y >= ROAD_H:
		road_b.position.y = road_a.position.y - ROAD_H
