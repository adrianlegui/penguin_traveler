extends Control

@export var label: Label = null


func _ready() -> void:
	label.text = str(Game.get_coins())
