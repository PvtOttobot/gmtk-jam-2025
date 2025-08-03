extends Control

signal level_won

@export var GameManager: Node

func _ready() -> void:
	GameManager.showEnd.connect(showEnd)

func showEnd():
	level_won.emit()
