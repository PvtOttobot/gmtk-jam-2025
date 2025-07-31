extends Node

@onready var progressBar: ProgressBar = $ProgressBar

@export var GameManager : Node

@export var goodReward : float = 5
@export var badPunishment : float = -5
@export var veryBadPunishment : float = -25

@export var amp  := 0.2
@export var freq := 8.0

@onready var director: Sprite2D = $Director

signal pullPlug

func _process(delta: float) -> void:
	# if we're censoring and the host is swearing - IS GOOD! 
	if (GameManager.isCensoring == true) && (GameManager.isSwearing == true):
		progressBar.value += goodReward * delta
		
	# if we're censoring and the host is not swearing - IS BAD! 
	if (GameManager.isCensoring == true) && (GameManager.isSwearing == false):
		progressBar.value += badPunishment * delta
		
	# if we're not censoring and the host is swearing - IS VERY BAD! 
	if (GameManager.isCensoring == true) && (GameManager.isSwearing == false):
		progressBar.value += veryBadPunishment * delta
		
	if (progressBar.value == 0):
		pullPlug.emit()
	
	wiggle()
	
func wiggle():
	director.rotation = sin(Time.get_ticks_msec() * 0.001 * freq) * amp
	
