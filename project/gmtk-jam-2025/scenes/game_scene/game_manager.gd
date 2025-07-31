extends Node

var isCensoring : bool = false
var isSwearing : bool = false
var isForwarding : bool = false
var isRewinding : bool = false

var currentNoteDuration : float = 0.0
var notePressedTime : float = 0

@onready var animation_player: AnimationPlayer = %AnimationManager

@export var staticShader: ColorRect

@export var lifeTime : float = 2
@export var rewindSpeed : float = -20
@export var forwardSpeed : float = 2

func _process(delta: float) -> void:
	if currentNoteDuration > 0.0:
		if isCensoring:
			print("hitting long")
		else:
			print("missing long")
		currentNoteDuration -= delta

func _unhandled_input(event: InputEvent) -> void:
	# hitting censor notes
	if Input.is_action_just_pressed("interact"):
		notePressedTime = animation_player.current_animation_position
		isCensoring = true
	elif Input.is_action_just_released("interact"):
		isCensoring = false

	# rewind the timeline
	if Input.is_action_just_pressed("rewind"):
		isRewinding = true
		currentNoteDuration = 0.0 
		animation_player.play("game",-1,rewindSpeed,true)
		
	elif Input.is_action_just_released("rewind"):
		isRewinding = false
		animation_player.play("game")
		
	# fast-forward 
	elif Input.is_action_just_pressed("forward"):
		isForwarding = true
		animation_player.play("game",-1,forwardSpeed,false)
	elif Input.is_action_just_released("forward"):
		isForwarding = false
		animation_player.play("game")
		
	if isRewinding == true:
		staticShader.visible = true
	else:
		staticShader.visible = false

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
