extends CharacterBody2D

@export var max_move_speed := 1200
@export var accel_rate := max_move_speed * 5
@export var damping_rate := 1.25
@onready var mms_neg := Vector2(-max_move_speed, -max_move_speed)
@onready var mms_pos := Vector2(max_move_speed, max_move_speed)

@onready var player := $"."

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	return

func _physics_process(delta: float) -> void:
	do_movement(delta)
	point_to_cursor()
	return

func point_to_cursor() -> void:
	var mouse_pos := get_global_mouse_position()
	
	# TODO: This will be replaced with the gun
	$Line2D.look_at(mouse_pos)
	
	# TODO: Update direction the player sprite is facing based on cursor pos
	
	return

func do_movement(delta: float) -> void:
	var up := Input.is_action_pressed(&"move_up")
	var lf := Input.is_action_pressed(&"move_left")
	var rt := Input.is_action_pressed(&"move_right")
	var dw := Input.is_action_pressed(&"move_down")
	var accel := Vector2.ZERO
	var damp := Vector2.ZERO
	
	if up: accel += Vector2(0,			-accel_rate)
	if lf: accel += Vector2(-accel_rate,0)
	if rt: accel += Vector2(accel_rate, 0)
	if dw: accel += Vector2(0,			accel_rate)
	
	var damping_factor := (1.0/damping_rate) - 1
	damp = Vector2(
		velocity.x * damping_factor, 
		velocity.y * damping_factor
	)
	
	velocity.x += damp.x + (accel.x * delta)
	velocity.y += damp.y + (accel.y * delta)
	velocity = velocity.clamp(mms_neg, mms_pos)
	move_and_slide()
	
	return
