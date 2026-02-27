extends Control

@onready var common_count: Label = %CommonCount
@onready var uncommon_count: Label = %UncommonCount
@onready var rare_count: Label = %RareCount
@onready var epic_count: Label = %EpicCount
@onready var legendary_count: Label = %LegendaryCount

func _ready() -> void:
	common_count.text = str(GameManager.get_inventory_count("common"))
	uncommon_count.text = str(GameManager.get_inventory_count("uncommon"))
	rare_count.text = str(GameManager.get_inventory_count("rare"))
	epic_count.text = str(GameManager.get_inventory_count("epic"))
	legendary_count.text = str(GameManager.get_inventory_count("legendary"))

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		get_tree().change_scene_to_file("res://screens/main_menu.tscn")
