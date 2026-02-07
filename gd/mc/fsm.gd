extends FSM

const STATE_STANDING := &"Standing"
const STATE_WALKING := &"Walking"
const STATE_JUMP := &"Jump"
const STATE_FALLING := &"Falling"
const STATE_DEAD := &"Dead"
const STATE_CELEBRATING := &"Celebrating"

@export var c: Character = null


func _on_entered(to: StringName) -> void:
	match to:
		STATE_DEAD:
			c.can_celebrate = false
			c.can_jump = false
			c.can_walk = false
			c.animation_player.play("Dead")
			c.velocity.y = 3.0
			Messenger.send_message(McDied.new())
		STATE_WALKING:
			c.look = Character.View.RIGHT
			c.animation_player.play("Walking")
		STATE_FALLING:
			c.animation_player.play("Falling", 1.0)
		STATE_JUMP:
			c.is_jumping = false
			c.animation_player.play("Jumping")
			c.skeleton_3d.transform = Transform3D.IDENTITY
		STATE_STANDING:
			c.animation_player.play("Standing", 0.5)
		STATE_CELEBRATING:
			c.look = Character.View.FRONT
			c.animation_player.play("Celebrate")


func _on_exited(from: StringName) -> void:
	if from == STATE_START:
		c.skeleton_3d.show_rest_only = false


@warning_ignore("unused_parameter")
func _on_transited(from: StringName, to: StringName) -> void:
	pass


func _process_current_state(delta: float) -> void:
	super._process_current_state(delta)
	match current_state:
		STATE_CELEBRATING:
			_process_state_celebrating()
		STATE_DEAD:
			_process_state_dead()
		STATE_FALLING:
			_process_state_falling()
		STATE_JUMP:
			_process_state_jump()
		STATE_STANDING:
			_process_state_standing()
		STATE_WALKING:
			_process_state_walking()


func _update_parameters() -> void:
	pass


func _process_state_start() -> void:
	current_state = STATE_STANDING


func _process_state_standing() -> void:
	var v := c.velocity
	v.x = move_toward(v.x, 0.0, 0.01)
	c.velocity = v

	if c.is_dead:
		current_state = STATE_DEAD
	elif c.is_celebrating:
		current_state = STATE_CELEBRATING
	elif not c.is_on_floor():
		current_state = STATE_FALLING
	elif c.can_walk and c.is_walking:
		current_state = STATE_WALKING
	elif c.can_jump and c.is_jumping and c.is_on_floor():
		current_state = STATE_JUMP


func _process_state_walking() -> void:
	c.velocity.x = c.speed * c.speed_multi

	if c.is_dead:
		current_state = STATE_DEAD
	elif c.is_celebrating:
		current_state = STATE_CELEBRATING
	elif not c.is_on_floor():
		current_state = STATE_FALLING
	elif not c.is_walking:
		current_state = STATE_STANDING
	elif c.can_jump and c.is_jumping and c.is_on_floor():
		current_state = STATE_JUMP


func _process_state_jump() -> void:
	c.velocity.y = c.jump_impulse * c.jump_multi

	if c.is_dead:
		current_state = STATE_DEAD
	elif c.is_celebrating:
		current_state = STATE_CELEBRATING
	else:
		current_state = STATE_FALLING


func _process_state_falling() -> void:
	c.velocity.y -= c.gravity * get_physics_process_delta_time()

	if c.is_dead:
		current_state = STATE_DEAD
	elif c.is_celebrating:
		current_state = STATE_CELEBRATING
	elif c.is_on_floor():
		current_state = STATE_STANDING


func _process_state_dead() -> void:
	c.velocity.x = move_toward(c.velocity.x, 0.0, 0.01)
	if not c.is_on_floor():
		c.velocity.y -= c.gravity * get_physics_process_delta_time()


func _process_state_celebrating() -> void:
	c.velocity.x = move_toward(c.velocity.x, 0.0, 0.01)
	if not c.is_on_floor():
		c.velocity.y -= c.gravity * get_physics_process_delta_time()
	if c.is_dead:
		current_state = STATE_DEAD
