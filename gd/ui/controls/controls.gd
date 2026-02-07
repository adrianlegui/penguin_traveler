extends Control


func _on_touch_screen_button_jump_pressed() -> void:
	var d := InputEventAction.new()
	d.action = "jump"
	d.pressed = true
	Input.parse_input_event(d)
	var u := InputEventAction.new()
	u.action = "jump"
	u.pressed = false
	Input.parse_input_event(u)


func _on_touch_screen_button_move_pressed() -> void:
	var s := InputEventAction.new()
	s.action = "spring"
	s.pressed = true
	Input.parse_input_event(s)


func _on_touch_screen_button_move_released() -> void:
	var s := InputEventAction.new()
	s.action = "spring"
	s.pressed = false
	Input.parse_input_event(s)
