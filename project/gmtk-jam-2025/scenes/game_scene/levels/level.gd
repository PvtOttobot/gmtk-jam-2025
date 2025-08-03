extends Node

signal level_lost
signal level_won
signal level_won_and_changed(level_path : String)

var level_state : LevelState

func open_tutorials() -> void:
	level_state.tutorial_read = true

func _ready() -> void:
	level_state = GameState.get_level_state(scene_file_path)
	if not level_state.tutorial_read:
		open_tutorials()

func _on_color_picker_button_color_changed(color : Color) -> void:
	level_state.color = color
	GlobalState.save()

func _on_tutorial_button_pressed() -> void:
	open_tutorials()
