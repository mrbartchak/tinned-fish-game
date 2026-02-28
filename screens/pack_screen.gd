class_name PackScreen
extends Control

@onready var fish_bucks_container: HBoxContainer = %FishBucksContainer

var spacing: float = 64.0
var center_x: float = 132
var center_y: float = 67.0
var offscreen_y: float = 180.0

var _selected_tin: TextureButton

@onready var open_btn: Button = %OpenButton

@onready var tin_left: TextureButton = %TinLeft
@onready var tin_center: TextureButton = %TinCenter
@onready var tin_right: TextureButton = %TinRight
@onready var tin_result: TextureRect = %TinResult

@onready var instruction_label: RichTextLabel = %InstructionLabel
@onready var fish_bucks_count: RichTextLabel = %FishBucksCount

@onready var paper_particles: GPUParticles2D = %PaperParticles

func _ready() -> void:
	set_process_input(false)
	GameFX.levitate(fish_bucks_container)
	tin_left.hide()
	tin_center.hide()
	tin_right.hide()
	tin_result.hide()
	tin_left.pressed.connect(_select_tin.bind(tin_left))
	tin_center.pressed.connect(_select_tin.bind(tin_center))
	tin_right.pressed.connect(_select_tin.bind(tin_right))
	open_btn.pressed.connect(enter)

func enter() -> void:
	tin_left.position = Vector2(center_x - spacing, offscreen_y)
	tin_center.position = Vector2(center_x, offscreen_y)
	tin_right.position = Vector2(center_x + spacing, offscreen_y)
	tin_left.show()
	tin_center.show()
	tin_right.show()
	instruction_label.text = ""
	fish_bucks_count.text = "[wave amp=4 freq=2]$%d" % GameManager.get_fish_bucks()
	set_process_input(false)
	
	_enter_tins()

func _enter_tins() -> void:
	AudioManager.play_tins_enter()
	GameFX.float_in(tin_left, center_y)
	GameFX.float_in(tin_center, center_y, 0.1)
	await GameFX.float_in(tin_right, center_y, 0.2).finished
	_on_tins_entered()

func _on_tins_entered() -> void:
	instruction_label.text = "[wave freq=1]Choose a tin!"
	
	GameFX.levitate(tin_left, randf_range(2.0,3.0), randf_range(1.5,2.0))
	GameFX.levitate(tin_center, randf_range(2.0,3.0), randf_range(1.5,2.0))
	GameFX.levitate(tin_right, randf_range(2.0,3.0), randf_range(1.5,2.0))

func _select_tin(selected_tin: TextureButton) -> void:
	_selected_tin = selected_tin
	tin_left.disabled = true
	tin_center.disabled = true
	tin_right.disabled = true
	GameFX.stop_levitate(tin_left)
	GameFX.stop_levitate(tin_center)
	GameFX.stop_levitate(tin_right)
	
	var unselected_tins = [tin_left, tin_center, tin_right].filter(func(t): return t != _selected_tin)
	
	GameFX.float_out(unselected_tins[0], offscreen_y)
	GameFX.float_out(unselected_tins[1], offscreen_y)
	
	var tween = create_tween()
	tween.tween_property(_selected_tin, "position", Vector2(center_x, center_y), 0.6)\
		.set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_BACK)
	AudioManager.play_swipe()
	
	tween.chain().tween_callback(_on_tin_centered)

func _on_tin_centered() -> void:
	AudioManager.play_soft_click()
	instruction_label.text = "[wave freq=2]Open it!"
	await get_tree().create_timer(0.15).timeout
	set_process_input(true)

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.is_pressed():
		set_process_input(false)
		_reveal()

func _reveal() -> void:
	var result: TinData = GameManager.open_pack()
	AudioManager.play_unwrap()
	paper_particles.emitting = true
	
	GameFX.scale_up(_selected_tin)
	var shake = GameFX.shake(_selected_tin)
	await shake.finished
	
	paper_particles.emitting = false
	AudioManager.play_reveal()
	var pop_hide = GameFX.pop_hide(_selected_tin)
	await pop_hide.finished
	
	_show_tin_result(result)

func _show_tin_result(result: TinData) -> void:
	tin_result.texture = result.texture
	tin_result.show()
	
	GameFX.levitate(tin_result)
	
	instruction_label.text = "[wave freq=8]%s!" % result.rarity.capitalize()
	instruction_label.add_theme_color_override("default_color", result.color)
	fish_bucks_count.text = "[wave amp=4 freq=2]$%d" % GameManager.get_fish_bucks()

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept"):
		get_tree().reload_current_scene()
	if event.is_action_pressed("ui_cancel"):
		get_tree().change_scene_to_file("res://screens/main_menu.tscn")
