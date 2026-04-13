extends Node

## Manages turn-based gameplay flow between player and enemy phases
## Handles tower activations and signals for turn transitions

# Enums
enum GamePhase {
	PLAYER_TURN,
	ENEMY_TURN,
	GAME_OVER
}

# Signals
signal player_turn_started(turn_number: int)
signal player_turn_ended
signal enemy_turn_started
signal enemy_turn_ended
signal energy_changed(remaining: int, max_energy: int)
signal game_over(player_won: bool)

# Export variables
@export_group("Turn Settings")
@export var max_energy: int = 7:  ## How many towers can be activated per turn
	get:
		return max_energy
	set(energy):
		max_energy = energy
		energy_changed.emit(energy, max_energy)
var energy_remaining: int = 0:
	get:
		return energy_remaining
	set(energy):
		energy_remaining = energy
		energy_changed.emit(energy, max_energy)

var current_phase: GamePhase = GamePhase.PLAYER_TURN
var turn_number: int = 0

@export_group("Debug")
@export var debug_mode: bool = true

func _ready() -> void:
	EnemyManager.enemies_turn_end.connect(end_enemy_turn)
	await get_tree().process_frame
	start_game()


## Initializes the game and starts the first player turn
func start_game() -> void:
	if debug_mode:
		print("[GameManager] Game started")
	
	
	
	turn_number = 0
	start_player_turn()


## Begins the player's turn
func start_player_turn() -> void:
	turn_number += 1
	current_phase = GamePhase.PLAYER_TURN
	
	energy_remaining = max_energy
	
	if debug_mode:
		print("[GameManager] Player turn %d started - %d energy available" % [turn_number, energy_remaining])
	
	player_turn_started.emit(turn_number)


## Attempts to activate a tower and use its ability
## Returns true if successful, false if activation failed
func activate_tower(t: Node) -> bool:
	# Validation checks
	if current_phase != GamePhase.PLAYER_TURN:
		if debug_mode:
			print("[GameManager] Cannot activate tower - not player turn")
		return false
	
	if energy_remaining <= 0:
		if debug_mode:
			print("[GameManager] Cannot activate tower - no energy remaining")
		return false
	
	# Activate the tower
	t.primary()
	energy_remaining -= 1
	
	if debug_mode:
		print("[GameManager] Tower activated - %d energy remaining" % energy_remaining)
	
	return true


## Ends the player turn and starts the enemy turn
func end_player_turn() -> void:
	if current_phase != GamePhase.PLAYER_TURN:
		if debug_mode:
			print("[GameManager] Cannot end player turn - not currently player turn")
		return
	
	player_turn_ended.emit()
	start_enemy_turn()


## Begins the enemy turn
func start_enemy_turn() -> void:
	current_phase = GamePhase.ENEMY_TURN
	
	if debug_mode:
		print("[GameManager] Enemy turn started")
	
	# Signal enemies to begin their turn (move and attack)
	enemy_turn_started.emit()


## Ends the enemy turn and returns to player turn
## Call this when all enemies have finished their actions
func end_enemy_turn() -> void:
	if current_phase != GamePhase.ENEMY_TURN:
		if debug_mode:
			print("[GameManager] Cannot end enemy turn - not currently enemy turn")
		return
	
	if debug_mode:
		print("[GameManager] Enemy turn ended")
	
	enemy_turn_ended.emit()
	start_player_turn()


## Ends the game with a win/loss result
func end_game(player_won: bool) -> void:
	current_phase = GamePhase.GAME_OVER
	
	if debug_mode:
		print("[GameManager] Game over - Player %s" % ("won" if player_won else "lost"))
	
	game_over.emit(player_won)


## Resets the game to initial state
func restart_game() -> void:
	start_game()


func is_player_turn() -> bool:
	return current_phase == GamePhase.PLAYER_TURN


func is_enemy_turn() -> bool:
	return current_phase == GamePhase.ENEMY_TURN


func can_activate_tower(t: Node) -> bool:
	if current_phase != GamePhase.PLAYER_TURN:
		return false
	if energy_remaining <= 0:
		return false
	if not t:
		print("[GameManager] Received a null reference while trying to activate a tower!")
		return false
	return true
