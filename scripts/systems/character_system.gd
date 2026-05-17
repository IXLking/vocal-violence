extends Node3D
# CharacterSystem - Chibi character creation and customization

class_name CharacterSystem

class ChibiCharacter:
	var character_name: String
	var base_model: Node3D
	var equipped_cosmetics: Dictionary
	var animation_player: AnimationPlayer
	
	func _init(p_name: String):
		character_name = p_name
		equipped_cosmetics = GameManager.equipped_cosmetics.duplicate()

var current_character: ChibiCharacter
var character_cache: Dictionary = {}

func _ready():
	create_character(GameManager.player_data["player_name"])

func create_character(name: String) -> ChibiCharacter:
	# Create a new chibi character with cosmetics
	
	if name in character_cache:
		return character_cache[name]
	
	var character = ChibiCharacter.new(name)
	var root = Node3D.new()
	root.name = name
	
	# Create base body (placeholder - should use proper 3D models)
	var body = MeshInstance3D.new()
	var capsule = CapsuleMesh.new()
	capsule.height = 2.0
	capsule.radius = 0.4
	body.mesh = capsule
	
	var body_material = StandardMaterial3D.new()
	body_material.albedo_color = Color.WHITE
	body.set_surface_override_material(0, body_material)
	root.add_child(body)
	
	# Create head (larger for chibi proportions)
	var head = MeshInstance3D.new()
	var head_mesh = SphereMesh.new()
	head_mesh.radius = 0.5
	head_mesh.height = 1.0
	head.mesh = head_mesh
	head.position.y = 1.0
	
	var head_material = StandardMaterial3D.new()
	head_material.albedo_color = Color.PEACH_PUFF
	head.set_surface_override_material(0, head_material)
	root.add_child(head)
	
	# Add cosmetics
	apply_cosmetics(root, character.equipped_cosmetics)
	
	character.base_model = root
	character_cache[name] = character
	current_character = character
	
	return character

func apply_cosmetics(character_root: Node3D, cosmetics: Dictionary) -> void:
	# Apply equipped cosmetics to character
	
	# Hat
	if cosmetics["hat"] != "none":
		var hat = create_hat(cosmetics["hat"])
		if hat:
			character_root.add_child(hat)
	
	# Shirt/Color
	if cosmetics["shirt"]:
		apply_shirt_color(character_root, cosmetics["shirt"])
	
	# Accessories
	if cosmetics.get("accessory"):
		var accessory = create_accessory(cosmetics["accessory"])
		if accessory:
			character_root.add_child(accessory)

func create_hat(hat_type: String) -> Node3D:
	# Create different hat types
	# TODO: Load actual hat models
	
	var hat = MeshInstance3D.new()
	var cone = BoxMesh.new()
	var material = StandardMaterial3D.new()
	
	match hat_type:
		"cap":
			cone = BoxMesh.new()
			material.albedo_color = Color.BLUE
		"crown":
			material.albedo_color = Color.GOLD
			material.emission = Color.GOLD
		"helmet":
			material.albedo_color = Color.DARK_GRAY
			material.metallic = 1.0
	
	hat.mesh = cone
	hat.set_surface_override_material(0, material)
	hat.position.y = 1.5
	
	return hat

func create_accessory(accessory_type: String) -> Node3D:
	# Create different accessory types (glasses, bags, etc.)
	# TODO: Load actual accessory models
	
	var accessory = MeshInstance3D.new()
	var mesh = SphereMesh.new()
	mesh.radius = 0.15
	accessory.mesh = mesh
	
	var material = StandardMaterial3D.new()
	material.albedo_color = Color.RED
	accessory.set_surface_override_material(0, material)
	accessory.position = Vector3(0.5, 0.8, 0)
	
	return accessory

func apply_shirt_color(character_root: Node3D, shirt_type: String) -> void:
	# Change the shirt/body color based on cosmetic
	var color = Color.WHITE
	
	match shirt_type:
		"hoodie":
			color = Color.DARK_BLUE
		"jacket":
			color = Color.BLACK
		_:
			color = Color.WHITE
	
	# Find and update body material
	for child in character_root.get_children():
		if child is MeshInstance3D and child.name != "Head":
			var mat = child.get_surface_override_material(0)
			if mat:
				mat.albedo_color = color

func equip_cosmetic(slot: String, cosmetic_id: String) -> void:
	# Equip a new cosmetic and update character
	GameManager.equip_cosmetic(slot, cosmetic_id)
	
	if current_character:
		current_character.equipped_cosmetics[slot] = cosmetic_id
		apply_cosmetics(current_character.base_model, current_character.equipped_cosmetics)

func get_character_node() -> Node3D:
	if current_character:
		return current_character.base_model
	return null
