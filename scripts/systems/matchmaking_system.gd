extends Node
# MatchmakingSystem - Real player matching with AI ghost player fallback

class_name MatchmakingSystem

class PlayerProfile:
	var player_id: String
	var name: String
	var trophy_rating: int
	var connection_quality: float
	var is_ghost_player: bool
	var character_cosmetics: Dictionary
	
	func _init(p_id: String, p_name: String, p_trophy: int, p_ghost: bool = false):
		player_id = p_id
		name = p_name
		trophy_rating = p_trophy
		is_ghost_player = p_ghost
		connection_quality = randf_range(0.8, 1.0) if not p_ghost else 1.0
		character_cosmetics = {}

var waiting_players: Array[PlayerProfile] = []
var search_active: bool = false
var search_timeout: float = 30.0
var current_search_time: float = 0.0

signal match_found(players: Array[PlayerProfile])
signal searching_started
signal searching_stopped

func _process(delta: float):
	if search_active:
		current_search_time += delta
		if current_search_time >= search_timeout:
			# Timeout - fill remaining slots with ghost players
			finalize_match_with_ghosts()

func start_matchmaking() -> void:
	if search_active:
		return
	
	search_active = true
	current_search_time = 0.0
	waiting_players.clear()
	
	# Add current player
	var current_player = PlayerProfile.new(
		str(randi()),
		GameManager.player_data["player_name"],
		GameManager.player_data["total_trophies"],
		false
	)
	waiting_players.append(current_player)
	
	searching_started.emit()
	print("Matchmaking started...")

func cancel_matchmaking() -> void:
	search_active = false
	waiting_players.clear()
	searching_stopped.emit()
	print("Matchmaking cancelled")

func finalize_match_with_ghosts() -> void:
	if not search_active:
		return
	
	search_active = false
	
	# Need at least 2 players for a match
	var players_needed = 4 - waiting_players.size()
	
	for i in range(players_needed):
		var ghost = create_ghost_player()
		waiting_players.append(ghost)
	
	searching_stopped.emit()
	match_found.emit(waiting_players)
	print("Match found! Players: ", waiting_players.size())

func create_ghost_player() -> PlayerProfile:
	# Create an AI ghost player that mimics human behavior
	var ghost_names = [
		"ShadowKnight",
		"VortexMage",
		"ThunderStrike",
		"FrostbiteQueen",
		"InfernoKing",
		"SilverArrow",
		"NovaBlast",
		"EchoPhantom",
	]
	
	var current_player_trophy = GameManager.player_data["total_trophies"]
	# Match skill level around current player
	var ghost_trophy = int(randf_range(
		current_player_trophy * 0.8,
		current_player_trophy * 1.2
	))
	
	var ghost = PlayerProfile.new(
		"ghost_" + str(randi()),
		ghost_names[randi() % ghost_names.size()],
		ghost_trophy,
		true
	)
	
	# Assign random cosmetics to ghost
	ghost.character_cosmetics = {
		"hat": ["none", "cap", "crown", "helmet"][randi() % 4],
		"shirt": ["default_shirt", "hoodie", "jacket"][randi() % 3],
		"color": Color.from_hsv(randf(), 0.8, 0.9),
	}
	
	return ghost

func get_player_skill_rating() -> int:
	return GameManager.player_data["total_trophies"]

func simulate_ghost_attack() -> String:
	# Simulate a ghost player voice attack
	var mock_attacks = [
		"THUNDER BOLT",
		"FIREBALL",
		"ICE SPIKE",
		"WIND SLASH",
		"COSMIC BLAST",
		"MEGA PUNCH",
	]
	
	return mock_attacks[randi() % mock_attacks.size()]
