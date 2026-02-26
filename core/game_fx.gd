extends Node

func float_in(node: Node, target_y: float, delay: float = 0.0) -> Tween:
	var tween = node.create_tween()
	tween.tween_property(node, "position:y", target_y, 0.8)\
		.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK).set_delay(delay)
	return tween

func float_out(node: Node, target_y: float) -> Tween:
	var tween = node.create_tween()
	tween.tween_property(node, "position:y", target_y, 0.4)\
		.set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_BACK)
	return tween

func scale_up(node: Node, target_scale: float = 1.2, duration: float = 0.75) -> Tween:
	var tween = node.create_tween()
	tween.tween_property(node, "scale", Vector2(target_scale, target_scale), duration)
	return tween

func levitate(node: Node, amplitude: float = 3.0, duration: float = 1.5) -> Tween:
	var tween = node.create_tween().set_loops()
	var base_y = node.position.y
	
	tween.tween_property(node, "position:y", base_y - amplitude, duration)\
		.set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
	tween.tween_property(node, "position:y", base_y, duration)\
		.set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
	node.set_meta("levitate_fx", tween)
	
	return tween

func stop_levitate(node: Node) -> void:
	if node.has_meta("levitate_fx"):
		node.get_meta("levitate_fx").kill()
		node.remove_meta("levitate_fx")

func shake(node: Node, duration: float = 1.2, intensity_start: float = 1.0, intensity_end: float = 4.0) -> Tween:
	var tween = node.create_tween()
	var original_position = node.position
	var steps = int(duration / 0.04)
	for i in range(steps):
		var intensity = remap(i, 0, steps - 1, intensity_start, intensity_end)
		var offset = Vector2(randf_range(-intensity, intensity), randf_range(-intensity, intensity))
		tween.tween_property(node, "position", original_position + offset, 0.04)
	tween.tween_property(node, "position", original_position, 0.01)
	return tween

func pop_hide(node: Node, scale_to: float = 1.8, duration: float = 0.1) -> Tween:
	var tween = node.create_tween()
	tween.tween_property(node, "scale", Vector2(scale_to, scale_to), duration)
	tween.parallel().tween_property(node, "modulate:a", 0.0, duration)
	tween.tween_callback(func():
		node.hide()
		node.modulate.a = 1.0
		node.scale = Vector2.ONE
	)
	return tween
