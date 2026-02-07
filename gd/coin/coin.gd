extends Collectable


func pick_up() -> void:
	Messenger.send_message(McPickUpSilverCoin.new())
	queue_free()
