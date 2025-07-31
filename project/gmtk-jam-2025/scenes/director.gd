extends Node

@onready var progressBar: ProgressBar = $ProgressBar

@export var goodReward : float
@export var badPunishment : float
@export var veryBadPunishment : float

signal pullPlug

func _process(delta: float) -> void:
	
	# if we're censoring and the host is swearing - IS GOOD! 
	if (%GameManager.isCensoring == true) && (%GameManager.isSwearing == true):
		progressBar.value += goodReward * delta
		
	# if we're censoring and the host is not swearing - IS BAD! 
	if (%GameManager.isCensoring == true) && (%GameManager.isSwearing == false):
		progressBar.value += badPunishment * delta
		
	# if we're not censoring and the host is swearing - IS VERY BAD! 
	if (%GameManager.isCensoring == true) && (%GameManager.isSwearing == false):
		progressBar.value += veryBadPunishment * delta
		
	if (progressBar.value == 0):
		pullPlug.emit()
