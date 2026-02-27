class_name Main
extends Control

const SCREEN_OFFSETS: Dictionary = {
	0: 320,
	1: 0,
	2: -320,
}
var screen_width: float = 320.0
var current_tab: int = 1

@onready var content: Control = %Content
@onready var collection_tab: TextureButton = %CollectionTab
@onready var home_tab: TextureButton = %HomeTab
@onready var pack_tab: TextureButton = %PackTab

func _ready() -> void:
	current_tab = 1
	content.position.x = SCREEN_OFFSETS[current_tab]
	collection_tab.pressed.connect(_switch_tab.bind(0))
	home_tab.pressed.connect(_switch_tab.bind(1))
	pack_tab.pressed.connect(_switch_tab.bind(2))

func _switch_tab(index: int) -> void:
	if index == current_tab:
		return
	current_tab = index
	var tween = create_tween()
	tween.tween_property(content, "position:x", SCREEN_OFFSETS[index], 1.5)\
		.set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_QUAD)
