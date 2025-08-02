extends Node

var buttons: Dictionary[String, Button] = {}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print('Input manager started')
	
func _process(delta: float) -> void:
	if(Input.is_action_pressed("censor")):
		print("Censor pressed: " , Input.is_action_pressed("censor"))
	if(Input.is_action_pressed("forward")):
		print("Censor pressed: " , Input.is_action_pressed("censor"))
	if(Input.is_action_pressed("rewind")):
		print("Censor pressed: " , Input.is_action_pressed("censor"))

# Call this method from the button's _ready() function to register itself
func register_button(button_node: Button, input_map_action: String) -> void:
	buttons[input_map_action] = button_node
	print(input_map_action + " button connected to InputManager")
	#button_node.connect("shoot_button_pressed", self, "_on_shoot_button_pressed")

## This method will be called when any registered button emits "shoot_button_pressed"
#func _on_shoot_button_pressed() -> void:
	## Add your centralized shoot logic here
	#print("Shoot action triggered from a UI button!")
	## Example: You might inform your Player node or a dedicated combat system
	## get_node("/root/Player").shoot_weapon()

#func register_button(key_name: String, button_node: Button) -> void:
	#if key_name.empty():
		#push_error("Cannot register button with an empty key name.")
		#return
#
	#if not _registered_buttons.has(key_name):
		#_registered_buttons[key_name] = button_node
		#print("Registered button '%s'." % key_name)
		## Optionally, connect the button's 'pressed' signal here to a central handler
		## This allows the GameManager to react to any registered button being pressed.
		## The [key_name] argument passes the button's key to the handler.
		#button_node.connect("pressed", self, "_on_registered_button_pressed", [key_name])
	#else:
		#push_warning("Button with key '%s' already registered. Overwriting existing reference." % key_name)
		## If overwriting, you might want to disconnect the old signal first
		#if is_instance_valid(_registered_buttons[key_name]):
			#_registered_buttons[key_name].disconnect("pressed", self, "_on_registered_button_pressed")
		#_registered_buttons[key_name] = button_node
		#button_node.connect("pressed", self, "_on_registered_button_pressed", [key_name])
