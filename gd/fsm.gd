class_name FSM extends Node
## Máquina de estados finitos.

enum InProcess { PROCESS, PHYSICS_PROCESS }

const STATE_START: StringName = &"START"
const STATE_FINISH: StringName = &"FINISH"

@export var where_process: InProcess = FSM.InProcess.PROCESS
var current_state: StringName = STATE_START:
	set = set_current_state


func _process(delta: float) -> void:
	if where_process == FSM.InProcess.PROCESS:
		_process_current_state(delta)
		_update_parameters()


func _physics_process(delta: float) -> void:
	if where_process == FSM.InProcess.PHYSICS_PROCESS:
		_process_current_state(delta)
		_update_parameters()


func set_current_state(state: StringName) -> void:
	if current_state == state:
		return

	var from: String = current_state
	current_state = state
	_on_exited(from)
	_on_entered(current_state)
	_on_transited(from, current_state)


@warning_ignore("unused_parameter")
func _on_transited(from: StringName, to: StringName) -> void:
	pass


@warning_ignore("unused_parameter")
func _on_entered(to: StringName) -> void:
	pass


@warning_ignore("unused_parameter")
func _on_exited(from: StringName) -> void:
	pass


func _process_current_state(_delta: float) -> void:
	match current_state:
		STATE_START:
			_process_state_start()
		STATE_FINISH:
			_process_state_finish()


func _process_state_start() -> void:
	pass


func _process_state_finish() -> void:
	pass


func _update_parameters() -> void:
	pass
