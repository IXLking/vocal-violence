extends Control
# Character customization menu

var character_preview: CharacterSystem
var selected_cosmetic: String = "shirt"

func _ready():
	setup_ui()
	setup_preview()

func setup_ui():
	# Create cosmetic category buttons
	var categories = ["hat", "shirt", "pants", "shoes", "accessories"]
	
	for category in categories:
		var button = Button.new()
		button.text = category.to_upper()
		button.pressed.connect(func(): _on_category_selected(category))
		add_child(button)
	
	# Back button
	var back_button = Button.new()
	back_button.text = "BACK"
	back_button.pressed.connect(_on_back_pressed)
	add_child(back_button)

func setup_preview():
	character_preview = CharacterSystem.new()
	character_preview.create_character(GameManager.player_data["player_name"])

func _on_category_selected(category: String):
	selected_cosmetic = category
	print("Selected category: ", category)
	# TODO: Show available cosmetics for this category

func _on_back_pressed():
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
