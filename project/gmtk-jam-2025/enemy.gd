extends Node2D

const SPEED = 50
var direction = 1
@onready var cast_left: RayCast2D = $CastLeft
@onready var cast_right: RayCast2D = $CastRight
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if cast_left.is_colliding():
		animated_sprite_2d.flip_h = false
		direction = 1
	if 	cast_right.is_colliding():
		animated_sprite_2d.flip_h = true
		direction = -1
	position.x += delta * SPEED * direction
