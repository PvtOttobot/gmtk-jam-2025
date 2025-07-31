@tool
extends Control

var _text: String = "Default button text"

@onready var button: Button = $Button

@export var text: String:
	get:
		return _text
	set(value):
		_text = value
		if is_node_ready() and is_instance_valid(button):
			button.text = _text
	
func _ready() -> void:
	if is_instance_valid(button):
		button.text = _text
