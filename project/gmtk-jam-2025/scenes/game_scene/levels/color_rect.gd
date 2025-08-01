extends ColorRect

@onready var level_1: Control = $"../.."

func _process(delta):
	global_position = level_1.global_position
	size = level_1.get_rect().size
