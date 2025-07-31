extends Node

var isCensoring : bool = false
var isSwearing : bool = false
var isRewinding : bool = false

@onready var animation_player: AnimationPlayer = %AnimationManager

@export var lifeTime : float = 1

func _unhandled_input(event: InputEvent) -> void:
	# hitting censor notes
	if event.is_action_pressed("interact"):
		isCensoring = true
		check_censor()

	# rewind the timeline
	if Input.is_action_just_pressed("rewind"):
		isRewinding = true
		animation_player.play_backwards("game")
	elif Input.is_action_just_released("rewind"):
		isRewinding = false
		animation_player.play("game")

func _on_timer_timeout() -> void:
	isCensoring = false

# the function used to place censor notes
###### DONT PUT ANY FUNCTIONS THAT ARENT censor_note() ON TRACK notes ######
func censor_note(duration: float) -> void:
	print(isCensoring)

# for checking the before half of hitting notes
func check_censor():
	var lookback = lifeTime / 2.0
	var current_time = animation_player.current_animation_position
	var start_time = max(0.0, current_time - lookback)
	var animation = animation_player.get_animation(animation_player.current_animation)
	if not animation:
		return

	var track_index = animation.find_track("notes", Animation.TYPE_METHOD)
	if track_index == -1:
		print("No 'notes' call method track found.")
		return

	for key_idx in animation.track_get_key_count(track_index):
		var key_time = animation.track_get_key_time(track_index, key_idx)
		var method_name = animation.track_get_key_value(track_index, key_idx)

		if key_time >= start_time and key_time <= current_time + (lifeTime / 2):
			print("hit")
			isCensoring = false
