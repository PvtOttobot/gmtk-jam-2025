extends Label


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	text = "branch: " + BuildInfo.BRANCH + " | date: " + BuildInfo.DATE + " | author: " + BuildInfo.AUTHOR + " | commit: '" + BuildInfo.MESSAGE + "'"
