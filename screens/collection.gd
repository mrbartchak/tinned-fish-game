extends Control

@onready var common_count: Label = %CommonCount
@onready var uncommon_count: Label = %UncommonCount
@onready var rare_count: Label = %RareCount
@onready var epic_count: Label = %EpicCount
@onready var legendary_count: Label = %LegendaryCount

func _ready() -> void:
	common_count.text = str(GameManager.get_count("common"))
	uncommon_count.text = str(GameManager.get_count("uncommon"))
	rare_count.text = str(GameManager.get_count("rare"))
	epic_count.text = str(GameManager.get_count("epic"))
	legendary_count.text = str(GameManager.get_count("legendary"))
