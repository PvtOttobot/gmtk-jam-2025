extends AnimatedSprite2D

@export var amp  := 0.2
@export var freq := 8.0

var _phase_offset := 0.0
var is_swearing = false

var wiggling : bool = false

func wiggleStart(amount: float, frequency: float) -> void:
	amp = amount
	freq = frequency
	_phase_offset = Time.get_ticks_msec() * 0.001 * freq
	wiggling = true

func wiggleEnd():
	wiggling = false
	
func start_swear():
	is_swearing = true
	modulate = Color(1.0, 0.23, 0.23)
	
func end_swear():
	is_swearing = false
	modulate = Color(1, 1, 1)

func _process(delta):
	if wiggling:
		var phase = Time.get_ticks_msec() * 0.001 * freq - _phase_offset
		rotation = sin(phase) * amp
		
