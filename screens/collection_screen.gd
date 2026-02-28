class_name CollectionScreen
extends Control

@onready var common_count: Label = %CommonCount
@onready var uncommon_count: Label = %UncommonCount
@onready var rare_count: Label = %RareCount
@onready var epic_count: Label = %EpicCount
@onready var legendary_count: Label = %LegendaryCount

func _ready() -> void:
	_update_counts()

func enter() -> void:
	_update_counts()

func _update_counts() -> void:
	common_count.text = str(GameManager.get_inventory_count("common"))
	uncommon_count.text = str(GameManager.get_inventory_count("uncommon"))
	rare_count.text = str(GameManager.get_inventory_count("rare"))
	epic_count.text = str(GameManager.get_inventory_count("epic"))
	legendary_count.text = str(GameManager.get_inventory_count("legendary"))
