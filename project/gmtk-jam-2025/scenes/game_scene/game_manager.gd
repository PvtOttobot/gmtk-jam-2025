extends Node

var isCensoring : bool = false
var isSwearing : bool = false
var isForwarding : bool = false
var isRewinding : bool = false

var currentNoteDuration : float = 0.0
var notePressedTime : float = 0
@onready var animation_player: AnimationPlayer = %AnimationManager
@onready var censor_popup_timer: Timer = %censorPopupTimer

@export var rewind_button: Button
@export var censor_button: Button
@export var fast_forward_button: Button
var disable_fast_forward: bool = false
var disable_censor: bool = false
@export var censor_button_length : float = 0.25

@export var staticShader: ColorRect

@export var lifeTime : float = 2
@export var rewindSpeed : float = -20
@export var forwardSpeed : float = 2

signal showEnd

func _ready() -> void:
	censor_popup_timer.wait_time = censor_button_length

func _process(delta: float) -> void:
	# rewinding logic to start of animationPlayer
	if(animation_player.current_animation_position <= 0 && isRewinding):
		rewind_full_toggle(false)

func _unhandled_input(event: InputEvent) -> void:
	# censor notes input logic
	if(!disable_censor):
		if Input.is_action_just_pressed("censor"):
			censor_toggle(true)

	# rewind input logic
	if Input.is_action_just_pressed("rewind"):
		rewind_full_toggle(true)
		
	# fast-forward 
	if(!disable_fast_forward):
		if Input.is_action_just_pressed("forward"):
			fast_forward_toggle(!isForwarding)

# rewind toggle logic
func rewind_full_toggle(toggle_on : bool):
	if(toggle_on):
		# reset censor & fast-forward
		censor_toggle(false)
		fast_forward_toggle(false)
		# re-enable fast forwarding
		disable_fast_forward = false
		isRewinding = true
		rewind_button.button_pressed = true
		staticShader.visible = true
		animation_player.play("game",-1,rewindSpeed,true)
	else:
		isRewinding = false
		rewind_button.button_pressed = false
		staticShader.visible = false
		animation_player.play("game")
		
# censor toggle logic
func censor_toggle(toggle_on : bool):
	if(toggle_on):
		isCensoring = true
		censor_button.button_pressed = true
		censor_popup_timer.start()
		disable_censor = true
		%censor_audio.play()
	else:
		isCensoring = false
		censor_button.button_pressed = false

# fast-forward toggle logic
func fast_forward_toggle(toggle_on : bool):
	if(toggle_on):
		isForwarding = true
		animation_player.play("game",-1,forwardSpeed,false)
		fast_forward_button.button_pressed = true
	else:
		isForwarding = false
		fast_forward_button.button_pressed = false
		animation_player.play("game")
		
# the function used to place swear notes
func swear_note() -> void:
	pass
	#var timeOffset = abs(notePressedTime - animation_player.current_animation_position)
	#print(timeOffset <= lifeTime)
	#if timeOffset <= lifeTime:
		#print("hit single")
	#else:
		#print("missed single")

# game won state
func animationEnd():
	print("GAME END")
	showEnd.emit()

# director fail state
func _on_director_pull_plug() -> void:
	disable_fast_forward = true
	#### in here implement tv shut off sound and pause
	pass # Replace with function body.


func _on_button_toggled(toggled_on: bool) -> void:
	if(toggled_on):
		%button_in_audio.play()
	else:
		%button_out_audio.play()


func _on_censor_popup_timer_timeout() -> void:
	disable_censor = false
	censor_toggle(false)
