class_name McGainCoins extends Message

var _number: int = 0


func _init(number: int = 0) -> void:
	_number = number


func get_number() -> int:
	return _number
