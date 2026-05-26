extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$HUD2.visible = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_play_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/main.tscn")


func _on_menu_button_pressed() -> void:
	if $HUD2.visible == false:
		$HUD2.visible = true
	else:
		$HUD2.visible = false


func _on_exit_button_pressed() -> void:
	$HUD2.visible = false
