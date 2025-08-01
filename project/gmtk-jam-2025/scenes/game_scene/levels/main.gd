extends Control

signal level_won

#@onready var GameManager: Node = %GameManager
#
#func _ready() -> void:
	#GameManager.showEnd.connect(showEnd)

func showEnd():
	level_won.emit()
