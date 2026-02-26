class_name GameState
extends RefCounted

var tin_collection: Dictionary = {
	"common": 0,
	"uncommon": 0,
	"rare": 0,
	"epic": 0,
	"legendary": 0
}
var fish_bucks: int = 0
var total_packs_opened: int = 0

func save_to_disk() -> void:
	var data = {
		"tin_collection": tin_collection,
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
	tin_collection = data.get("tin_collection", tin_collection)
	fish_bucks = data.get("fish_bucks", fish_bucks)
	total_packs_opened = data.get("total_packs_opened", total_packs_opened)
