extends Node
#
## for director emotion states
#enum Emotions {NORMAL, NEUTRAL, NEGATIVE, POSITIVE}
#var currentEmotion = Emotions.NORMAL
#@onready var neutral_face: Sprite2D = $Director/emotions/neutral_face
#@onready var negative_face: Sprite2D = $Director/emotions/negative_face
#@onready var positive_face: Sprite2D = $Director/emotions/positive_face
#
#@onready var progressBar: ProgressBar = $ProgressBar
#var resumeAfterPlug : bool = true
#
#@export var GameManager : Node
#
#@export var goodReward : float = 5
#@export var badPunishment : float = -25
#@export var veryBadPunishment : float = -25
#
#@export var amp  := 0.2
#@export var freq := 8.0
#
#@onready var director: AnimatedSprite2D = $Director
#
#signal pullPlug
#
#func display_emotion(emotion:Emotions,duration:float):
	#emotion_visibility(emotion)
	#%EmotionTimer.wait_time = duration #emotion timeout
#
#func emotion_visibility(emotion:Emotions):
	#neutral_face.visible = false
	#negative_face.visible = false
	#positive_face.visible = false
	#if (emotion == Emotions.NEUTRAL):
		#neutral_face.visible = true
	#elif (emotion == Emotions.NEGATIVE):
		#negative_face.visible = true
	#elif (emotion == Emotions.POSITIVE):
		#positive_face.visible = true
	#
#func _process(delta: float) -> void:
	#if(GameManager.isRewinding && !resumeAfterPlug): 
		#emotion_visibility(Emotions.NORMAL)
		#resumeAfterPlug = true
	#if (GameManager.animation_player.is_playing()):
		## if we're censoring and the host is swearing - IS GOOD! 
		#if (GameManager.isCensoring == true) && (GameManager.isSwearing == true):
			#display_emotion(Emotions.POSITIVE,0.1)
			#progressBar.value += goodReward * delta
		#
		## if we're not censoring and the host is not swearing - IS GOOD! 
		#elif (GameManager.isCensoring == false) && (GameManager.isSwearing == false):
			#progressBar.value += goodReward * delta
			#
		## if we're censoring and the host is not swearing - IS BAD! 
		#elif (GameManager.isCensoring == true) && (GameManager.isSwearing == false):
			#display_emotion(Emotions.NEUTRAL,0.1)
			#progressBar.value += badPunishment * delta
			#
		## if we're not censoring and the host is swearing - IS VERY BAD! 
		#elif (GameManager.isCensoring == false) && (GameManager.isSwearing == true):
			#display_emotion(Emotions.NEGATIVE,0.1)
			#progressBar.value += veryBadPunishment * delta
	#
	## game end condition
	#if (progressBar.value <= 0.0):
		#pullPlug.emit()
#
## timer timout to change emotion to normal after duration is over
#func _on_emotion_timer_timeout() -> void:
	#emotion_visibility(Emotions.NORMAL)
#
#func _on_pull_plug() -> void:
	## show director angry
	#director.play("plug")
	#emotion_visibility(Emotions.NEGATIVE)
	#GameManager.animation_player.pause() # stop the broadcast
	## bool to check if player rewinds and resume playing
	#resumeAfterPlug = false
