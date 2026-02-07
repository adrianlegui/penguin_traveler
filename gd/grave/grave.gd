extends Node3D

@export var mc: Character
@export var button_ressurect: Button


func resurrect() -> void:
	mc.visible = true
	Messenger.send_message(McResurrect.new())
	mc.animation_player.play("Resurrect")
	await mc.animation_player.animation_finished
	mc.animation_player.play("Standing")
	await get_tree().create_timer(5.0).timeout
	queue_free()
	Messenger.send_message(McGoHome.new())


func _ready() -> void:
	Messenger.message_sent.connect(_process_message)


@warning_ignore("unused_parameter")
func _process_message(message: Message) -> void:
	pass


func _on_button_button_up() -> void:
	resurrect()
	button_ressurect.visible = false
