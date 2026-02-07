extends Node3D

@export var button_go_to_smoke_tests_map: Button


func _ready() -> void:
	button_go_to_smoke_tests_map.visible = OS.is_debug_build()


func _on_button_go_button_up() -> void:
	var pck := load("res://gd/map/map_0001.tscn") as PackedScene
	Game.change_map(pck.instantiate())
	queue_free()


func _on_button_go_to_smoke_tests_map_button_up() -> void:
	var pck := load("res://gd/map/smoke_tests.tscn") as PackedScene
	Game.change_map(pck.instantiate())
	queue_free()
