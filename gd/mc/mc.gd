class_name Character extends CharacterBody3D

enum View { RIGHT, FRONT }

@export var look: View = View.FRONT:
	set(value):
		if value == look:
			return
		look = value
		if look == View.RIGHT:
			root.transform = Transform3D.IDENTITY.looking_at(Vector3.RIGHT, Vector3.UP, true)
		elif look == View.FRONT:
			root.transform = Transform3D.IDENTITY
@export var root: Node3D = null
@export var skeleton_3d: Skeleton3D = null
@export var ray_cast_3d: RayCast3D = null
@export var animation_player: AnimationPlayer = null
@export var gravity: float = 7.5
@export_range(0.1, 20.0) var speed: float = 2.0
@export_range(0.1, 20.0) var speed_multi: float = 1.0
@export_range(0.1, 20.0) var jump_impulse: float = 5.0
@export_range(0.1, 20.0) var jump_multi: float = 1.0

var can_jump: bool = true
var is_jumping: bool = false
var is_walking: bool = false
var can_walk: bool = true
var is_dead: bool = false
var can_celebrate: bool = true
var is_celebrating: bool = false


func add_deformed_mesh(scene: MeshInstance3D):
	skeleton_3d.add_child.call_deferred(scene, true)
	await scene.ready
	scene.skeleton = scene.get_path_to(skeleton_3d)


func equip(item: Item) -> void:
	if item.is_equipable():
		add_deformed_mesh(item.packed_scene.instantiate())


func kill() -> void:
	is_dead = true


func push(direction: Vector3) -> void:
	velocity += direction


func celebrate() -> void:
	is_celebrating = true


@warning_ignore("unused_parameter")
func _physics_process(delta: float) -> void:
	move_and_slide()
	if is_on_floor() and ray_cast_3d.is_colliding():
		var n := ray_cast_3d.get_collision_normal()
		var t := _align_with_y(skeleton_3d.global_transform, n)
		skeleton_3d.global_transform = skeleton_3d.global_transform.interpolate_with(t, 12 * delta)


func _on_collector_area_entered(area: Area3D) -> void:
	if is_dead:
		return
	var c := area as Collectable
	if c:
		var m := McPickupThing.new()
		Messenger.send_message(m)
		c.pick_up()


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("move"):
		is_walking = true
	elif event.is_action_pressed("stop"):
		is_walking = false
	elif is_on_floor() and event.is_action_released("jump"):
		is_jumping = true
	elif event.is_action_pressed("sprint"):
		speed_multi = 2.0
	elif event.is_action_released("sprint"):
		speed_multi = 1.0


func _align_with_y(xform: Transform3D, new_y: Vector3) -> Transform3D:
	xform.basis.y = new_y
	xform.basis.x = -xform.basis.z.cross(new_y)
	xform.basis = xform.basis.orthonormalized()
	return xform
