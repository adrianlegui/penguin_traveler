extends Area3D


func _on_body_entered(body: Node3D) -> void:
	var character := body as Character
	if not character or character.is_dead:
		return

	character.celebrate()
	Messenger.send_message(McFinishMap.new())
	await get_tree().create_timer(5.0).timeout
	Messenger.send_message(McGoHome.new())
