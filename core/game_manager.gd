extends Node

var _state: GameState

var tins: Array[TinData] = [
	preload("res://tins/common_tin.tres"),
	preload("res://tins/uncommon_tin.tres"),
	preload("res://tins/rare_tin.tres"),
	preload("res://tins/epic_tin.tres"),
	preload("res://tins/legendary_tin.tres")
]

func _ready() -> void:
	_state = GameState.new()
	_state.load_from_disk()

func get_fish_bucks() -> int:
	return _state.fish_bucks

func add_fish_bucks(amount: int) -> void:
	_state.fish_bucks += amount
	_state.save_to_disk()

func open_pack() -> TinData:
	var result = _roll_tin()
	_state.tin_collection[result.rarity] += 1
	add_fish_bucks(result.value)
	return result

func _roll_tin() -> TinData:
	var total_weight = 0
	for tin: TinData in tins:
		total_weight += tin.weight
	var roll = randi() % total_weight
	var cumulative = 0
	for tin: TinData in tins:
		cumulative += tin.weight
		if roll < cumulative:
			return tin
	return tins[0]
