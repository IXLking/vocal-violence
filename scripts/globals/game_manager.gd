extends Node
# GameManager - Global player progression and state management

class_name GameManager

const SAVE_PATH = "user://vocal_violence_save.json"

# Player profile data
var player_data = {
	"player_name": "Player",
	"level": 1,
	"total_trophies": 0,
	"matches_won": 0,
	"matches_played": 0,
	"favorite_character": "default_chibi",
}

# Cosmetics unlock system
var unlocked_cosmetics = {
	"hats": ["none"],
	"shirts": ["default_shirt"],
	"pants": ["default_pants"],
	"shoes": ["default_shoes"],
	"accessories": [],
	"voice_effects": [],
	"emotes": [],
	"trails": [],
}

# Current equipped cosmetics
var equipped_cosmetics = {
	"hat": "none",
	"shirt": "default_shirt",
	"pants": "default_pants",
	"shoes": "default_shoes",
	"accessory": null,
	"voice_effect": null,
	"emote": null,
	"trail": null,
}

# Settings
var game_settings = {
	"master_volume": 1.0,
	"sfx_volume": 1.0,
	"music_volume": 0.8,
	"voice_sensitivity": 0.5,
	"microphone_index": 0,
	"push_to_talk_enabled": false,
	"noise_suppression": true,
	"echo_cancellation": true,
}

func _ready():
	set_process(false)
	load_game()

func save_game():
	var save_data = {
		"player_data": player_data,
		"unlocked_cosmetics": unlocked_cosmetics,
		"equipped_cosmetics": equipped_cosmetics,
		"game_settings": game_settings,
	}
	
	var json = JSON.stringify(save_data)
	var file = FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	if file:
		file.store_string(json)
		print("Game saved successfully")
	else:
		print("Error saving game")

func load_game():
	if ResourceLoader.exists(SAVE_PATH):
		var file = FileAccess.open(SAVE_PATH, FileAccess.READ)
		if file:
			var json_string = file.get_as_text()
			var json = JSON.new()
			if json.parse(json_string) == OK:
				var data = json.data
				player_data = data.get("player_data", player_data)
				unlocked_cosmetics = data.get("unlocked_cosmetics", unlocked_cosmetics)
				equipped_cosmetics = data.get("equipped_cosmetics", equipped_cosmetics)
				game_settings = data.get("game_settings", game_settings)
				print("Game loaded successfully")
			else:
				print("Error parsing save file")
	else:
		print("No save file found. Starting fresh.")

func add_trophies(amount: int):
	player_data["total_trophies"] += amount
	check_level_up()

func check_level_up():
	var required_trophies = player_data["level"] * 100
	if player_data["total_trophies"] >= required_trophies:
		player_data["level"] += 1
		print("LEVEL UP! Level: ", player_data["level"])

func record_match(won: bool):
	player_data["matches_played"] += 1
	if won:
		player_data["matches_won"] += 1
		add_trophies(50)
	else:
		add_trophies(10)

func unlock_cosmetic(cosmetic_type: String, cosmetic_id: String):
	if cosmetic_type in unlocked_cosmetics:
		if cosmetic_id not in unlocked_cosmetics[cosmetic_type]:
			unlocked_cosmetics[cosmetic_type].append(cosmetic_id)
			print("Unlocked: ", cosmetic_id)

func equip_cosmetic(cosmetic_slot: String, cosmetic_id: String):
	if cosmetic_id in unlocked_cosmetics.get(cosmetic_slot + "s", []):
		equipped_cosmetics[cosmetic_slot] = cosmetic_id
		print("Equipped: ", cosmetic_id)

func get_win_rate() -> float:
	if player_data["matches_played"] == 0:
		return 0.0
	return float(player_data["matches_won"]) / float(player_data["matches_played"])
