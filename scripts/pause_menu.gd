extends CanvasLayer

func _ready() -> void:
	visible = false
	GameManager.game_paused.connect(_on_paused)
	GameManager.game_resumed.connect(_on_resumed)

func _on_paused() -> void:
	visible = true

func _on_resumed() -> void:
	visible = false

func _on_play_button_pressed() -> void:
	GameManager.resume()


func _on_replay_button_pressed() -> void:
	get_tree().paused = false
	GameManager.end_game("RESTARTED") 
	get_tree().reload_current_scene()


func _on_menu_button_pressed() -> void:
	get_tree().paused = false
	GameManager.end_game("RETURN TO MENU") 
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")


func _on_exit_button_pressed() -> void:
	GameManager.resume()
