extends Node3D

var move_speed := 10.0
var rotate_speed := 90.0   # degrees per second
var grid_snap := 1.0       # tile size

var zoom_min := 4.0
var zoom_max := 8.0
var zoom_speed := 1.0

var zoom_target := 25.0

@onready var camera: Camera3D = $Pivot/Camera3D
@onready var pivot := $Pivot

func _ready():
	zoom_target = camera.position.y

func _process(delta):
	handle_movement(delta)
	handle_rotation(delta)
	handle_zoom(delta)

func handle_movement(delta):
	var input_dir := Vector3.ZERO
	if Input.is_action_pressed("s"):
		input_dir.z -= 1
	if Input.is_action_pressed("w"):
		input_dir.z += 1
	if Input.is_action_pressed("a"):
		input_dir.x -= 1
	if Input.is_action_pressed("d"):
		input_dir.x += 1
	if input_dir == Vector3.ZERO:
		return
	input_dir = input_dir.normalized()
	# Move relative to camera rotation
	
	var forward: Vector3 = -pivot.global_transform.basis.z
	var right: Vector3 = pivot.global_transform.basis.x
	var move_vec: Vector3 = (forward * input_dir.z) + (right * input_dir.x)
	move_vec.y = 0
	
	self.global_position += move_vec * move_speed * delta
	
	#snap_to_grid()

func handle_rotation(delta):
	var rotate_dir := 0

	if Input.is_action_pressed("q"):
		rotate_dir += 1
	if Input.is_action_pressed("e"):
		rotate_dir -= 1

	if rotate_dir != 0:
		pivot.rotate_y(deg_to_rad(rotate_dir * rotate_speed * delta))

func handle_zoom(delta):
	if Input.is_action_just_pressed("zoom in"):
		zoom_target -= zoom_speed
	if Input.is_action_just_pressed("zoom out"):
		zoom_target += zoom_speed

	zoom_target = clamp(zoom_target, zoom_min, zoom_max)

	# Smooth zoom
	camera.position.y = lerp(camera.position.y, zoom_target, 10 * delta)
	camera.position.z = lerp(camera.position.z, zoom_target, 10 * delta)

func snap_to_grid():
	global_position.x = snapped(global_position.x, grid_snap)
	global_position.z = snapped(global_position.z, grid_snap)
