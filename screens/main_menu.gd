extends Control

var pack_opener_scene: PackedScene = preload("res://screens/pack_opener.tscn")
var collection_scene: PackedScene = preload("res://screens/collection.tscn")


func _on_open_pack_button_pressed() -> void:
	get_tree().change_scene_to_packed(pack_opener_scene)


func _on_collection_button_pressed() -> void:
	get_tree().change_scene_to_packed(collection_scene)
