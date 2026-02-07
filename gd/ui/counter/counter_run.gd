extends Control

@export var label: Label = null

var _counter: int = 0


func _process_message(message: Message) -> void:
	if message as McPickUpSilverCoin:
		_counter += 1
		label.text = str(_counter)
	elif message as CounterReset:
		_counter = 0
		label.text = str(_counter)
	elif message as McFinishMap:
		Messenger.send_message(McGainCoins.new(_counter))


func _ready() -> void:
	Messenger.message_sent.connect(_process_message)
