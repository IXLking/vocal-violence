extends Control
# Matchmaking lobby scene - waiting room with player list

var matchmaking_system: MatchmakingSystem
var player_cards: Array[Node] = []

func _ready():
	matchmaking_system = MatchmakingSystem.new()
	add_child(matchmaking_system)
	
	setup_ui()
	start_matchmaking()

func setup_ui():
	# Create waiting room UI
	var waiting_label = Label.new()
	waiting_label.text = "Searching for players..."
	add_child(waiting_label)
	
	var cancel_button = Button.new()
	cancel_button.text = "CANCEL"
	cancel_button.pressed.connect(_on_cancel_pressed)
	add_child(cancel_button)

func start_matchmaking():
	matchmaking_system.searching_started.connect(_on_searching_started)
	matchmaking_system.searching_stopped.connect(_on_searching_stopped)
	matchmaking_system.match_found.connect(_on_match_found)
	
	matchmaking_system.start_matchmaking()

func _on_searching_started():
	print("Searching for players...")

func _on_searching_stopped():
	print("Search stopped")

func _on_match_found(players: Array):
	print("Match found with ", players.size(), " players")
	for player in players:
		print(" - ", player.name, " (Trophy: ", player.trophy_rating, ")")
	
	get_tree().change_scene_to_file("res://scenes/arena.tscn")

func _on_cancel_pressed():
	matchmaking_system.cancel_matchmaking()
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
