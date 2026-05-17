extends Control
# Settings menu - audio, microphone, and game settings

var voice_system: VoiceSystem

func _ready():
	voice_system = VoiceSystem.new()
	add_child(voice_system)
	
	setup_audio_settings()
	setup_microphone_settings()

func setup_audio_settings():
	# Volume controls
	var master_volume_label = Label.new()
	master_volume_label.text = "Master Volume"
	add_child(master_volume_label)
	
	var master_slider = HSlider.new()
	master_slider.min_value = 0.0
	master_slider.max_value = 1.0
	master_slider.step = 0.05
	master_slider.value = GameManager.game_settings["master_volume"]
	master_slider.value_changed.connect(func(value): GameManager.game_settings["master_volume"] = value)
	add_child(master_slider)

func setup_microphone_settings():
	# Microphone device selection
	var mic_label = Label.new()
	mic_label.text = "Microphone Device"
	add_child(mic_label)
	
	var devices = voice_system.get_microphone_devices()
	for i in range(devices.size()):
		var button = Button.new()
		button.text = devices[i]
		button.pressed.connect(func(): voice_system.set_microphone_device(i))
		add_child(button)
	
	# Voice sensitivity slider
	var sensitivity_label = Label.new()
	sensitivity_label.text = "Voice Sensitivity"
	add_child(sensitivity_label)
	
	var sensitivity_slider = HSlider.new()
	sensitivity_slider.min_value = 0.0
	sensitivity_slider.max_value = 1.0
	sensitivity_slider.step = 0.1
	sensitivity_slider.value = GameManager.game_settings["voice_sensitivity"]
	sensitivity_slider.value_changed.connect(func(value): voice_system.set_voice_sensitivity(value))
	add_child(sensitivity_slider)
	
	# Test microphone button
	var test_button = Button.new()
	test_button.text = "TEST MICROPHONE"
	test_button.pressed.connect(func(): voice_system.test_microphone())
	add_child(test_button)
	
	# Back button
	var back_button = Button.new()
	back_button.text = "BACK"
	back_button.pressed.connect(_on_back_pressed)
	add_child(back_button)

func _on_back_pressed():
	GameManager.save_game()
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
