extends Node
# VoiceSystem - Microphone input and speech-to-text processing

class_name VoiceSystem

var audio_input: AudioStreamMicrophone
var recording: bool = false
var captured_audio_buffer: PackedFloat32Array = []

signal voice_detected(phrase: String, confidence: float, volume: float)
signal listening_started
signal listening_stopped

func _ready():
	audio_input = AudioStreamMicrophone.new()
	setup_microphone()

func setup_microphone():
	var devices = AudioServer.get_input_device_list()
	if devices.is_empty():
		print("ERROR: No microphone input devices found!")
		return
	
	var selected_device = GameManager.game_settings["microphone_index"]
	if selected_device >= devices.size():
		selected_device = 0
	
	var device_name = devices[selected_device]
	print("Selected microphone: ", device_name)

func start_listening():
	if recording:
		return
	
	recording = true
	captured_audio_buffer.clear()
	listening_started.emit()
	print("Listening started...")

func stop_listening():
	if not recording:
		return
	
	recording = false
	listening_stopped.emit()
	process_voice_input()

func process_voice_input():
	if captured_audio_buffer.is_empty():
		return
	
	# Analyze voice characteristics
	var volume = calculate_volume(captured_audio_buffer)
	var confidence = 0.85 # Placeholder - integrate with real STT API
	
	# Mock speech recognition - replace with real API
	var recognized_phrase = mock_recognize_speech()
	
	if not recognized_phrase.is_empty():
		voice_detected.emit(recognized_phrase, confidence, volume)
		print("Voice detected: %s (confidence: %.2f, volume: %.2f)" % [recognized_phrase, confidence, volume])

func calculate_volume(audio_data: PackedFloat32Array) -> float:
	if audio_data.is_empty():
		return 0.0
	
	var sum_squares = 0.0
	for sample in audio_data:
		sum_squares += sample * sample
	
	var rms = sqrt(sum_squares / audio_data.size())
	return clamp(rms * 2.0, 0.0, 1.0)

func mock_recognize_speech() -> String:
	# TODO: Integrate with real speech-to-text API (Google Cloud, Azure, etc.)
	# For now, return mock phrases for testing
	var mock_phrases = [
		"THUNDER BOLT",
		"FIRE DRAGON",
		"ICE SPIKE",
		"WIND SLASH",
		"EARTH QUAKE",
		"LIGHTNING STORM",
	]
	
	return mock_phrases[randi() % mock_phrases.size()]

func get_microphone_devices() -> PackedStringArray:
	return AudioServer.get_input_device_list()

func set_microphone_device(device_index: int):
	var devices = get_microphone_devices()
	if device_index >= 0 and device_index < devices.size():
		GameManager.game_settings["microphone_index"] = device_index
		setup_microphone()

func set_voice_sensitivity(value: float):
	GameManager.game_settings["voice_sensitivity"] = clamp(value, 0.0, 1.0)

func test_microphone() -> void:
	# Test microphone input and show feedback
	print("Testing microphone input...")
	start_listening()
	await get_tree().create_timer(2.0).timeout
	stop_listening()
