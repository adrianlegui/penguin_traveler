extends Node

signal main_character_ready

const DATA := "user://continue.sav"
const PASS := "e8e4b6b7ba2da8b1bc8690f1b617a79b9b3dc86fa119a7cc418bb7eefb55738b"
const MC_IS_DEAD := "mc_is_dead"
const COINS := "coins"
const MC := preload("uid://dh4fror121t8w") as PackedScene
const CAMERA := preload("uid://dnd1v6kj77fn7") as PackedScene

var _coins: int = 0

var _mc: Character = null
var _map: Map = null
var _camera: Camera = null
var _home: Node3D = null
var _mc_is_dead: bool = false


func start() -> void:
	_load()
	if _mc_is_dead:
		_go_grave()
	else:
		_go_home()


func _notification(what: int) -> void:
	if what in [Node.NOTIFICATION_WM_CLOSE_REQUEST, Node.NOTIFICATION_WM_GO_BACK_REQUEST]:
		_save()


func _go_home() -> void:
	_remove_map()
	_remove_mc()
	var pck := load("res://gd/home/home.tscn") as PackedScene
	_home = pck.instantiate()
	add_child.call_deferred(_home)
	await _home.ready


func _remove_map() -> void:
	if _map:
		_map.queue_free()
		await _map.tree_exited
		_map = null


func _remove_mc() -> void:
	if _mc:
		_mc.queue_free()
		await _mc.tree_exited
		_mc = null


func get_coins() -> int:
	return _coins


func get_main_character() -> Character:
	return _mc


func change_map(map: Map) -> void:
	Messenger.send_message(CounterReset.new())

	var scene_tree := get_tree()
	scene_tree.paused = true

	if _map:
		_map.queue_free()
		await _map.tree_exited
		_map = null

	_map = map
	add_child.call_deferred(_map)
	await _map.ready
	_add_main_character()
	_conf_camera()
	_mc.is_walking = true

	scene_tree.paused = false


func _add_main_character() -> void:
	if _mc:
		_mc.queue_free()
		await _mc.tree_exited
	_mc = MC.instantiate()
	_mc.position = _map.spawn_point.global_position
	add_child.call_deferred(_mc)
	await _mc.ready
	main_character_ready.emit()


func _conf_camera() -> void:
	if _camera:
		_camera.queue_free()
		await _camera.tree_exited
	_camera = CAMERA.instantiate()
	add_child.call_deferred(_camera)
	await _camera.ready
	var PC3D := _camera.PC3D
	PC3D.follow_target = _mc
	_camera.process_mode = Node.PROCESS_MODE_INHERIT


func _ready() -> void:
	Messenger.message_sent.connect(_process_message)


func _process_message(message: Message) -> void:
	if message as McDied:
		_mc_is_dead = true
		_save()
		await _wait_mc_stop()
		_go_grave()
	elif message as McGainCoins:
		var c := message as McGainCoins
		_coins += c.get_number()
		_save()
	elif message as McGoHome:
		_go_home()
	elif message as McGoGrave:
		_go_grave()
	elif message as McResurrect:
		_mc_is_dead = false
		_save()


func _wait_mc_stop() -> void:
	while not _mc.velocity.is_zero_approx():
		await get_tree().process_frame
	await get_tree().create_timer(5.0).timeout


func _go_grave() -> void:
	if _mc:
		_mc.queue_free()
		_mc = null
	if _map:
		_map.queue_free()
		_map = null
	if _camera:
		_camera.queue_free()
		_camera = null
	var g := load("res://gd/grave/grave.tscn") as PackedScene
	add_child.call_deferred(g.instantiate())


func _save() -> void:
	var d := {MC_IS_DEAD: _mc_is_dead, COINS: _coins}
	var f := FileAccess.open_encrypted_with_pass(DATA, FileAccess.WRITE, PASS)
	if not f:
		return
	f.store_var(d)
	f.close()


func _load() -> void:
	var f := FileAccess.open_encrypted_with_pass(DATA, FileAccess.READ, PASS)
	if not f:
		return

	var d := f.get_var() as Dictionary
	if not d:
		return
	_mc_is_dead = d.get(MC_IS_DEAD, false)
	_coins = d.get(COINS, 0)
