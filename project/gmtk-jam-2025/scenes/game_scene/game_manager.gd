extends Node

var isCensoring : bool = false
var isSwearing : bool = false
var isForwarding : bool = false
var isRewinding : bool = false

@onready var animation_player: AnimationPlayer = %AnimationManager
@onready var censor_popup_timer: Timer = %censorPopupTimer

@export var rewind_button: Button
@export var censor_button: Button
@export var fast_forward_button: Button
var disable_fast_forward: bool = false
var disable_censor: bool = false
@export var censor_button_length : float = 0.25
var current_talk_show_face : Sprite2D
var has_hit_swear_note : bool = false
@export var censor_forgivness : float = 20

@export var staticShader: ColorRect

@export var crtShader: ColorRect
var crt_shader: ShaderMaterial

@export var forwardSpeed : float = 2

@export var rewind_audio: AudioStreamPlayer
@onready var lose_audio: AudioStreamPlayer = $"../LoseAudio"

signal showEnd
signal swearNoteHit
signal swearNoteMiss
signal censorNoSwear

func _ready() -> void:
	censor_popup_timer.wait_time = censor_button_length
	crt_shader = (crtShader.material as ShaderMaterial).duplicate()
	crtShader.material = crt_shader

func _process(delta: float) -> void:
	# swearing logic
	if(isSwearing && isCensoring && !has_hit_swear_note && !%censorDurationTimer.is_stopped()):
		has_hit_swear_note = true
	# censor without swear
	if(isCensoring && !isSwearing):
		censorNoSwear.emit()
		isCensoring = false
	
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
		lose_audio.stop()
		
		animate_tv_on()
		
		AudioServer.set_bus_solo(AudioServer.get_bus_index("Rewind"), true)

		rewind_audio.play()
		# reset censor & fast-forward
		censor_toggle(false)
		fast_forward_toggle(false)
		# re-enable fast forwarding
		disable_fast_forward = false
		isRewinding = true
		rewind_button.button_pressed = true
		staticShader.visible = true
		
		var pos = animation_player.current_animation_position
		var rewind_time = 3.0
		var speed = -(pos / rewind_time)
		animation_player.play("game", -1, speed, true)
		
		%TalkShowGuest.get_child(0).visible = false
		%TalkShowHost.get_child(0).visible = false
		%censorDurationTimer.stop()
	else:
		
		AudioServer.set_bus_solo(AudioServer.get_bus_index("Rewind"), false)
		
		isRewinding = false
		%screenShutOffPopup.visible = false
		rewind_button.button_pressed = false
		staticShader.visible = false
		animation_player.play("game")
		%TalkShowGuest.get_child(0).visible = false
		%TalkShowHost.get_child(0).visible = false
		
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
func swear_note(duration: float, character : String) -> void:
	# get character face
	if(character == "host"):
		current_talk_show_face = %TalkShowHost.get_child(0)
	elif(character == "guest"):
		current_talk_show_face = %TalkShowGuest.get_child(0)
	# face logic 
	current_talk_show_face.visible = true
	if(isRewinding):
		return
	
	%censorDurationTimer.wait_time = duration*2
	%censorDurationTimer.start()
	isSwearing = true

# game won state
func animationEnd():
	print("GAME END")
	showEnd.emit()

# director fail state
func _on_director_pull_plug() -> void:
	disable_fast_forward = true
	animate_tv_off()
	lose_audio.play()
	
# all button sound effects
func _on_button_toggled(toggled_on: bool) -> void:
	if(toggled_on):
		%button_in_audio.play()
	else:
		%button_out_audio.play()

# censor button logic
func _on_censor_popup_timer_timeout() -> void:
	disable_censor = false
	censor_toggle(false)

func _on_censor_duration_timer_timeout() -> void:
	current_talk_show_face.visible = false
	isSwearing = false
	
	if (has_hit_swear_note):
		swearNoteHit.emit()
	else:
		swearNoteMiss.emit()
		has_hit_swear_note = false
	%noteFeedbackTimer.start()
	%directorFeedbackTimer.start()
	
# for touch controls on button
func _on_reverse_bottom_panel_simple_button_pressed() -> void:
	rewind_full_toggle(true)
	
func _on_censor_bottom_panel_simple_button_pressed() -> void:
	censor_toggle(true)

func _on_fast_forward_bottom_panel_simple_button_pressed() -> void:
	fast_forward_toggle(true)	

func animate_tv_off():
	var tween := get_tree().create_tween()
	var track := tween.tween_property(crt_shader,"shader_parameter/power", 1.0 ,0.5)
	track.set_trans(Tween.TRANS_CUBIC)
	track.set_ease(Tween.EASE_IN_OUT)
	%CRTPopupTimer.start()
	
func animate_tv_on():
	var tween := get_tree().create_tween()
	var track := tween.tween_property(crt_shader,"shader_parameter/power", 0.0 ,0.5)
	%screenShutOffPopup.visible = false
	track.set_trans(Tween.TRANS_CUBIC)
	track.set_ease(Tween.EASE_IN_OUT)

func _on_crt_popup_timer_timeout() -> void:
	%screenShutOffPopup.visible = true

func _on_note_feedback_timer_timeout() -> void:
	print("signal note : ", has_hit_swear_note)
	if(has_hit_swear_note):
		%correct_note_audio.play()
	else:
		%incorrect_note_audio.play()
