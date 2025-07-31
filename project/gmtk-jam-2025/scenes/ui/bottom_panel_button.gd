@tool
extends Control

var _texture_normal: AtlasTexture
var _texture_pressed: AtlasTexture

@onready var texture_button: TextureButton = $MarginContainer/TextureButton

@export var texture_normal: AtlasTexture:
	get:
		return _texture_normal
	set(value):
		_texture_normal = value
		apply_textures()

@export var texture_pressed: AtlasTexture:
	get:
		return _texture_pressed
	set(value):
		_texture_pressed = value
		apply_textures()

func _ready() -> void:
	apply_textures()

func apply_textures() -> void:
	if is_node_ready() and is_instance_valid(texture_button):
			texture_button.texture_normal = _texture_normal
			texture_button.texture_pressed = _texture_pressed
