extends Node

var isCensoring : bool = false
var isSwearing : bool = false
var isForwarding : bool = false
var isRewinding : bool = false

var currentNoteDuration : float = 0.0
var notePressedTime : float = 0
@onready var animation_player: AnimationPlayer = %AnimationManager

@export var rewind_button: Button
@export var censor_button: Button
@export var fast_forward_button: Button

@export var staticShader: ColorRect

@export var lifeTime : float = 2
@export var rewindSpeed : float = -20
@export var forwardSpeed : float = 2

signal showEnd

func _ready() -> void:
	%censorTimeoutTimer.wait_time = lifeTime / 4

func _process(delta: float) -> void:
	# rewinding logic
	if(animation_player.current_animation_position <= 0 && isRewinding):
		isRewinding = false
		currentNoteDuration = 0.0 
		animation_player.play("game")
		rewind_button.button_pressed = false
		
	if isRewinding == true:
		staticShader.visible = true
	else:
		staticShader.visible = false
	
	if currentNoteDuration > 0.0:
		if isCensoring:
			print("hitting long")
		else:
			print("missing long")
		currentNoteDuration -= delta

func _unhandled_input(event: InputEvent) -> void:
	# hitting censor notes
	if Input.is_action_pressed("interact") && !Input.is_action_just_pressed("interact"):
		%censorTimeoutTimer.stop()
	elif Input.is_action_just_pressed("interact"):
		isCensoring = true
		censor_button.button_pressed = true
		%censorTimeoutTimer.start()
	elif(Input.is_action_just_released("interact") && %censorTimeoutTimer.is_stopped()):
		isCensoring = false
		censor_button.button_pressed = false
	elif(Input.is_action_just_released("interact") && !%censorTimeoutTimer.is_stopped()):
		notePressedTime = animation_player.current_animation_position

	# rewind the timeline
	if Input.is_action_just_pressed("rewind"):
		isRewinding = true
		currentNoteDuration = 0.0 
		rewind_button.button_pressed = true
		fast_forward_button.button_pressed = false
		animation_player.play("game",-1,rewindSpeed,true)
		
	elif Input.is_action_just_released("rewind"):
		isRewinding = false
		animation_player.play("game")
	# fast-forward 
	elif Input.is_action_just_pressed("forward"):
		if(!isForwarding):
			isForwarding = true
			fast_forward_button.button_pressed = true
			animation_player.play("game",-1,forwardSpeed,false)
		else:
			isForwarding = false
			fast_forward_button.button_pressed = false
			animation_player.play("game")

# the function used to place swear notes
func swear_note_single() -> void:
	var timeOffset = abs(notePressedTime - animation_player.current_animation_position)
	print(timeOffset <= lifeTime)
	if timeOffset <= lifeTime:
		print("hit single")
	else:
		print("missed single")
	
func swear_note_long(duration: float) -> void:
	currentNoteDuration = duration

func _on_rewind_button_toggled(toggled_on: bool) -> void:
	if toggled_on:
		isRewinding = true
		currentNoteDuration = 0.0 
		animation_player.play("game",-1,rewindSpeed,true)

func _on_censor_button_toggled(toggled_on: bool) -> void:
	if(toggled_on):
		isCensoring = true
		%censorTimeoutTimer.start()

func _on_fast_forward_button_toggled(toggled_on: bool) -> void:
	if(toggled_on):
		isForwarding = true
		animation_player.play("game",-1,forwardSpeed,false)
	else:
		isForwarding = false
		animation_player.play("game")

func _on_censor_timeout_timer_timeout() -> void:
	isCensoring = false
	censor_button.button_pressed = false
	%censorTimeoutTimer.stop()

func animationEnd():
	showEnd.emit()


func _on_director_pull_plug() -> void:
	pass # Replace with function body.
	
func start_swear():
	pass
	
func end_swear():
	pass
	
func swear_start_signal_recieved() -> void:
	isSwearing = true

func swear_end_signal_recieved() -> void:
	isSwearing = false

func _on_talk_show_host_signal_swear_start() -> void:
	swear_start_signal_recieved()

func _on_talk_show_host_signal_swear_end() -> void:
	swear_end_signal_recieved()

func _on_talk_show_guest_signal_swear_end() -> void:
	swear_end_signal_recieved()

func _on_talk_show_guest_signal_swear_start() -> void:
	swear_start_signal_recieved()
