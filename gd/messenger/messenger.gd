extends Node

const WHAT := "what"

signal message_sent(message: Message)


func send_message(message: Message) -> void:
	message_sent.emit(message)
