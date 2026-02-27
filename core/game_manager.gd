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

#region Readers
func get_fish_bucks() -> int:
	return _state.fish_bucks

func get_inventory_count(rarity: String = "all") -> int:
	if rarity == "all":
		var tin_count: int = 0
		var values: Array[int] = _state.tin_inventory.values()
		for value in values:
			tin_count += value
		return tin_count
	return _state.tin_inventory.get(rarity)

func get_total_collected(rarity: String = "all") -> int:
	if rarity == "all":
		var total: int = 0
		var values: Array[int] = _state.total_tins_collected.values()
		for value in values:
			total += value
		return total
	return _state.total_tins_collected.get(rarity)
#endregion

#region Actions
func add_fish_bucks(amount: int) -> void:
	_state.fish_bucks += amount
	_state.save_to_disk()

func open_pack() -> TinData:
	var result = _roll_tin()
	_state.total_tins_collected[result.rarity] += 1
	_state.tin_inventory[result.rarity] += 1
	#add_fish_bucks(result.value)
	_state.save_to_disk()
	return result

func sell_tin(tin: TinData) -> bool:
	if _state.tin_inventory[tin.rarity] <= 0:
		return false
	_state.tin_inventory[tin.rarity] -= 1
	add_fish_bucks(tin.value)
	return true
#endregion

#region Internal
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

#endregion
