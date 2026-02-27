class_name GameState
extends RefCounted

var total_packs_opened: int = 0
var total_tins_collected: Dictionary = {
	"common": 0,
	"uncommon": 0,
	"rare": 0,
	"epic": 0,
	"legendary": 0
}
var tin_inventory: Dictionary = {
	"common": 0,
	"uncommon": 0,
	"rare": 0,
	"epic": 0,
	"legendary": 0
}
var fish_bucks: int = 0

func save_to_disk() -> void:
	var data = {
		"total_tins_collected": total_tins_collected,
		"tin_inventory": tin_inventory,
		"fish_bucks": fish_bucks,
		"total_packs_opened": total_packs_opened
	}
	var file = FileAccess.open("user://save.json", FileAccess.WRITE)
	file.store_string(JSON.stringify(data))

func load_from_disk() -> void:
	if not FileAccess.file_exists("user://save.json"):
		return
	var file = FileAccess.open("user://save.json", FileAccess.READ)
	var data: Dictionary = JSON.parse_string(file.get_as_text())
	tin_inventory = data.get("tin_inventory", tin_inventory)
	fish_bucks = data.get("fish_bucks", fish_bucks)
	total_packs_opened = data.get("total_packs_opened", total_packs_opened)
	total_tins_collected = data.get("total_tins_collected", total_tins_collected)
