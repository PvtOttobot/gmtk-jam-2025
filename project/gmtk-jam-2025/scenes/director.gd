extends Node

# for director emotion states
enum Emotions {NORMAL, NEUTRAL, NEGATIVE, POSITIVE}
var currentEmotion = Emotions.NORMAL
@onready var neutral_face: Sprite2D = $Director/emotions/neutral_face
@onready var negative_face: Sprite2D = $Director/emotions/negative_face
@onready var positive_face: Sprite2D = $Director/emotions/positive_face

@onready var progressBar: ProgressBar = $ProgressBar
var resumeAfterPlug : bool = true
var lastAudioName : String = ""

@export var GameManager : Node

@export var goodReward : float = 5
@export var badPunishment : float = -25

@export var amp  := 0.2
@export var freq := 8.0
@export var ThreshholdAnger : float = 70

@onready var director: AnimatedSprite2D = $Director

signal pullPlug

func display_emotion(emotion:Emotions,duration:float):
	emotion_visibility(emotion)
	%EmotionTimer.wait_time = duration #emotion timeout

func emotion_visibility(emotion:Emotions):
	currentEmotion = emotion
	neutral_face.visible = false
	negative_face.visible = false
	positive_face.visible = false
	if (emotion == Emotions.NEUTRAL):
		neutral_face.visible = true
	elif (emotion == Emotions.NEGATIVE):
		negative_face.visible = true
	elif (emotion == Emotions.POSITIVE):
		positive_face.visible = true
		
func play_audio(audioName : String) -> bool:
	# dont play audio if an audio is playing
	for sound in %Audio.get_children():
		if (sound.playing && sound.name == audioName || lastAudioName == audioName):
			return false
			
	var AudioPlayer : AudioStreamPlayer2D = %Audio.get_node(audioName)
	if (!AudioPlayer):
		return false
		
	AudioPlayer.play()
	lastAudioName = AudioPlayer.name
	return true
	
func _process(delta: float) -> void:
	# reset progress
	if(GameManager.isRewinding):
		progressBar.value = 100
	# resuming after plugpulled
	if(GameManager.isRewinding && !resumeAfterPlug): 
		emotion_visibility(Emotions.NORMAL)
		director.play("default")
		resumeAfterPlug = true
	if (GameManager.animation_player.is_playing()):
		# game end condition
		if (progressBar.value <= 0.0):
			pullPlug.emit()

# timer timout to change emotion to normal after duration is over
func _on_emotion_timer_timeout() -> void:
	lastAudioName = ""
	emotion_visibility(Emotions.NORMAL)

func _on_pull_plug() -> void:
	# show director angry
	director.play("plug")
	play_audio("unplug_socket_audio")
	emotion_visibility(Emotions.NEGATIVE)
	GameManager.animation_player.pause() # stop the broadcast
	# bool to check if player rewinds and resume playing
	resumeAfterPlug = false

func _on_game_manager_swear_note_hit() -> void:
	progressBar.value += goodReward
	display_emotion(Emotions.POSITIVE,0.1)
	print("swear note hit")

func _on_game_manager_swear_note_miss() -> void:
	if (progressBar.value < ThreshholdAnger):
		display_emotion(Emotions.NEGATIVE,0.1)
	else:
		display_emotion(Emotions.NEUTRAL,0.1)
	progressBar.value += badPunishment
	print("swear note miss")


func _on_director_feedback_timer_timeout() -> void:
	GameManager.has_hit_swear_note = false
	if (currentEmotion == Emotions.NEUTRAL):
		play_audio("neutral_face_audio")
	elif (currentEmotion == Emotions.NEGATIVE):
		play_audio("negative_face_audio")
	elif (currentEmotion == Emotions.POSITIVE):
		play_audio("positive_face_audio")
