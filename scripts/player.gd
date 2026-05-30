extends CharacterBody3D

@onready var cam_mount: Node3D = $cam_mount

var dir: Vector3
var cur_speed: Vector3
var target_speed
var max_speed:= 30
var accel:= 5
var cam_accel:= 8
var mouseY = 0.0
var smooth_mouseY:= 0.0
var mouse_sens_y = 0.1
var mouseX = 0.0
var smooth_mouseX:= 0.0
var mouse_sens_x = 0.1



func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		mouseY += event.relative.y
		mouseX += event.relative.x

func _physics_process(delta: float) -> void:
	basic_movement(delta)
	vel_set(delta)
	cam_movement(delta)
	
	move_and_slide()
	print(mouseX)

func basic_movement(delta):
	dir = Vector3.ZERO
	
	if Input.is_action_pressed("W"):
		dir -= global_transform.basis.z
	if Input.is_action_pressed("A"):
		dir -= global_transform.basis.x
	if Input.is_action_pressed("S"):
		dir += global_transform.basis.z
	if Input.is_action_pressed("D"):
		dir += global_transform.basis.x
	
	dir = dir.normalized()
	target_speed = dir*max_speed
	
	cur_speed = lerp(cur_speed, target_speed, accel*delta)
	

func vel_set(delta):
	velocity.x = cur_speed.x
	velocity.z = cur_speed.z

func cam_movement(delta):
	mouseY = clamp(mouseY, -80/mouse_sens_y, 80/mouse_sens_y)
	
	smooth_mouseX = lerp(smooth_mouseX, mouseX, cam_accel*delta)
	smooth_mouseY = lerp(smooth_mouseY, mouseY, cam_accel*delta)
	
	cam_mount.rotation.x = deg_to_rad(-smooth_mouseY) * mouse_sens_y
	rotation.y = deg_to_rad(-smooth_mouseX) * mouse_sens_x
