extends Control
# Main menu scene controller

var character_preview: Node3D
var animation_player: AnimationPlayer

func _ready():
	setup_ui()
	setup_character_preview()

func setup_ui():
	# Create main menu buttons
	var play_button = Button.new()
	play_button.text = "PLAY"
	play_button.pressed.connect(_on_play_pressed)
	add_child(play_button)
	
	var customize_button = Button.new()
	customize_button.text = "CUSTOMIZE"
	customize_button.pressed.connect(_on_customize_pressed)
	add_child(customize_button)
	
	var settings_button = Button.new()
	settings_button.text = "SETTINGS"
	settings_button.pressed.connect(_on_settings_pressed)
	add_child(settings_button)

func setup_character_preview():
	# Create a 3D viewport for character preview
	var char_system = CharacterSystem.new()
	character_preview = char_system.create_character(GameManager.player_data["player_name"]).base_model

func _on_play_pressed():
	print("Play button pressed!")
	get_tree().change_scene_to_file("res://scenes/matchmaking_lobby.tscn")

func _on_customize_pressed():
	print("Customize button pressed!")
	get_tree().change_scene_to_file("res://scenes/character_customization.tscn")

func _on_settings_pressed():
	print("Settings button pressed!")
	get_tree().change_scene_to_file("res://scenes/settings_menu.tscn")
