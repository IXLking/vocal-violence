extends Node3D
# AttackGenerator - Converts voice phrases to dynamic 3D attacks

class_name AttackGenerator

class Attack:
	var name: String
	var damage: float
	var size: float
	var color: Color
	var effect_type: String
	var duration: float
	
	func _init(p_name: String, p_damage: float, p_size: float, p_color: Color, p_effect: String, p_duration: float = 2.0):
		name = p_name
		damage = p_damage
		size = p_size
		color = p_color
		effect_type = p_effect
		duration = p_duration

var attack_library = {
	# Fire attacks
	"fire": Attack("Fireball", 25.0, 1.0, Color.ORANGE, "fireball", 2.0),
	"flame": Attack("Flame Burst", 20.0, 0.8, Color.RED, "flame", 1.5),
	"blaze": Attack("Inferno", 40.0, 1.5, Color.DARK_RED, "blaze", 3.0),
	
	# Ice attacks
	"ice": Attack("Ice Spike", 20.0, 0.9, Color.CYAN, "ice", 2.0),
	"frost": Attack("Frozen Armor", 15.0, 1.2, Color.LIGHT_BLUE, "frost", 2.5),
	"blizzard": Attack("Blizzard", 35.0, 1.4, Color.WHITE, "blizzard", 3.0),
	
	# Lightning attacks
	"lightning": Attack("Thunder Bolt", 30.0, 0.7, Color.YELLOW, "lightning", 1.8),
	"thunder": Attack("Thunderstorm", 35.0, 1.3, Color.YELLOW, "thunder", 2.5),
	"zap": Attack("Zap Zap", 15.0, 0.5, Color.GOLD, "zap", 1.2),
	
	# Wind attacks
	"wind": Attack("Wind Slash", 18.0, 0.8, Color.LIGHT_CYAN, "wind", 1.5),
	"tornado": Attack("Tornado", 32.0, 1.3, Color.LIGHT_GRAY, "tornado", 2.8),
	"gust": Attack("Gust", 12.0, 0.6, Color.LIGHT_BLUE, "gust", 1.0),
	
	# Earth attacks
	"earth": Attack("Earth Quake", 28.0, 1.2, Color.BROWN, "earth", 2.2),
	"rock": Attack("Boulder Throw", 22.0, 0.9, Color.DARK_GRAY, "rock", 1.8),
	"sand": Attack("Sand Tornado", 25.0, 1.1, Color.TAN, "sand", 2.0),
	
	# Cosmic attacks
	"laser": Attack("Laser Beam", 40.0, 0.8, Color.MAGENTA, "laser", 1.5),
	"meteor": Attack("Meteor Strike", 50.0, 1.5, Color.RED, "meteor", 2.5),
	
	# Food attacks (for fun!)
	"burrito": Attack("Burrito Burst", 18.0, 1.0, Color.ORANGE_RED, "burrito", 1.8),
	"pizza": Attack("Pizza Throw", 16.0, 0.9, Color.ORANGE, "pizza", 1.6),
	"noodles": Attack("Noodle Whip", 14.0, 0.7, Color.GOLDENROD, "noodles", 1.4),
}

func parse_voice_phrase(phrase: String, volume: float) -> Attack:
	# Convert volume to damage multiplier (0.5 to 2.0)
	var damage_multiplier = lerp(0.5, 2.0, volume)
	
	# Clean and analyze the phrase
	var phrase_lower = phrase.to_lower()
	var best_match: Attack = null
	var highest_relevance = 0.0
	
	# Try to match keywords in the phrase
	for keyword in attack_library.keys():
		if keyword in phrase_lower:
			var relevance = float(phrase_lower.count(keyword)) / phrase_lower.length()
			if relevance > highest_relevance:
				highest_relevance = relevance
				best_match = attack_library[keyword]
	
	# If no match found, create a generic random attack
	if best_match == null:
		best_match = generate_creative_attack(phrase, damage_multiplier)
	else:
		# Apply damage multiplier
		best_match.damage *= damage_multiplier
		best_match.size *= pow(damage_multiplier, 0.5)
	
		return best_match
	return best_match

func generate_creative_attack(phrase: String, damage_multiplier: float) -> Attack:
	# Generate attacks for creative/unknown phrases
	# Combine elements from the phrase
	
	var random_attack_names = [
		"Chaos Burst",
		"Void Strike",
		"Reality Warp",
		"Cosmic Flare",
		"Dimensional Rift",
	]
	
	var random_colors = [
		Color.RED,
		Color.BLUE,
		Color.GREEN,
		Color.MAGENTA,
		Color.YELLOW,
		Color.CYAN,
	]
	
	var name = random_attack_names[randi() % random_attack_names.size()]
	var base_damage = 20.0 * damage_multiplier
	var size = 1.0 * pow(damage_multiplier, 0.5)
	var color = random_colors[randi() % random_colors.size()]
	
	return Attack(name, base_damage, size, color, "generic", 2.0)

func create_attack_effect(attack: Attack, position: Vector3, direction: Vector3) -> Node3D:
	# Create a visual attack effect in the 3D world
	# TODO: Implement actual particle systems and 3D models
	
	var effect = Node3D.new()
	effect.name = attack.name
	effect.position = position
	
	# Create a simple colored sphere for now (placeholder)
	var mesh_instance = MeshInstance3D.new()
	var sphere_mesh = SphereMesh.new()
	sphere_mesh.radius = attack.size
	mesh_instance.mesh = sphere_mesh
	
	var material = StandardMaterial3D.new()
	material.albedo_color = attack.color
	material.emission = attack.color
	material.emission_energy_multiplier = 1.0
	mesh_instance.set_surface_override_material(0, material)
	
	effect.add_child(mesh_instance)
	
	# Add movement
	var tween = create_tween()
	tween.tween_property(effect, "position", position + direction * 50.0, attack.duration)
	tween.callback(func(): effect.queue_free())
	
	return effect
