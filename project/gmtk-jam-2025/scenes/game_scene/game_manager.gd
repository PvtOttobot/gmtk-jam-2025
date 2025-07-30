extends Node

var isCensoring : bool = false
@onready var timer: Timer = $Timer

@export var lifeTime : float = 1

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("interact"):
		isCensoring = true
		timer.start()
	

func _ready() -> void:
	timer.wait_time = lifeTime
	

func _on_timer_timeout() -> void:
	isCensoring = false

func printBazinga(word) -> void:
	print(word)
