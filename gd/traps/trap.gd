extends Area3D

@export var push_force: float = 5.0
@export var active: bool = true


func _on_body_entered(body: Node3D) -> void:
	if not active:
		return

	var c := body as Character
	if c and not c.is_dead:
		active = false
		c.push(Vector3.UP * push_force)
		c.kill()
