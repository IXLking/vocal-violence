extends Node3D
# Arena scene - main combat gameplay

var players: Array = []
var attack_generator: AttackGenerator
var voice_system: VoiceSystem
var current_match_time: float = 0.0
var match_duration: float = 180.0  # 3 minutes

func _ready():
	setup_arena()
	setup_systems()

func setup_arena():
	# Create basic arena environment
	var ground = MeshInstance3D.new()
	var plane = PlaneMesh.new()
	plane.size = Vector2(100, 100)
	ground.mesh = plane
	
	var ground_material = StandardMaterial3D.new()
	ground_material.albedo_color = Color.DARK_GRAY
	ground.set_surface_override_material(0, ground_material)
	add_child(ground)
	
	# Add lighting
	var light = DirectionalLight3D.new()
	light.rotation_degrees = Vector3(-45, 45, 0)
	add_child(light)

func setup_systems():
	attack_generator = AttackGenerator.new()
	voice_system = VoiceSystem.new()
	add_child(voice_system)
	
	voice_system.voice_detected.connect(_on_voice_detected)

func _process(delta: float):
	current_match_time += delta
	
	if current_match_time >= match_duration:
		end_match()

func _on_voice_detected(phrase: String, confidence: float, volume: float):
	print("Attack detected: %s (volume: %.2f)" % [phrase, volume])
	
	var attack = attack_generator.parse_voice_phrase(phrase, volume)
	print("Generated attack: %s (damage: %.1f)" % [attack.name, attack.damage])
	
	# Create visual attack effect
	var attack_effect = attack_generator.create_attack_effect(
		attack,
		Vector3(0, 1, -10),
		Vector3(0, 0, -1)
	)
	add_child(attack_effect)

func end_match():
	print("Match ended!")
	# TODO: Calculate winner, awards, update progression
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
