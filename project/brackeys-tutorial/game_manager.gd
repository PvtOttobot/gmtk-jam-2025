extends Node

@onready var ui: Node = %UI

var score = 0

func add_point():
	score += 1
	ui.get_node("Score").text = "Coins: " + str(score)
