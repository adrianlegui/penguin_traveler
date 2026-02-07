class_name Item extends Resource

@export var equipable: bool = false
@export var packed_scene: PackedScene = null


func is_equipable() -> bool:
	return equipable
