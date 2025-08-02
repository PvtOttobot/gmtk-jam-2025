extends Button

@export var input_map_action: String

var standby = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if(input_map_action):
		InputManager.register_button(self, input_map_action)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if(is_pressed()):
		Input.action_press(input_map_action)
		standby = false
	elif(!standby):
		Input.action_release(input_map_action)

#func _on_button_up() -> void:
	#Input.action_release(input_map_action)
	#print(input_map_action + "-button: up")
#
#func _on_button_down() -> void:
	#Input.action_press(input_map_action)
	#print(input_map_action + "-button: down")
#
#func _on_pressed() -> void:
	#print(input_map_action + "-button: pressed")
#
#func _on_toggled(toggled_on: bool) -> void:
	#print(input_map_action + "-button toggled: " , toggled_on)
