class_name BaseEntity
extends CharacterBody2D

const default_mms := 1200
const default_accel := 5 * Vector2(default_mms, default_mms)
const default_damp := 1.25

var max_move_speed: float = default_mms
var accel_rate: Vector2 = default_accel
var damping_rate: float = default_damp
@onready var mms_neg: Vector2
@onready var mms_pos: Vector2

func _init(mms: float = default_mms, accel: Vector2 = default_accel, damping: float = default_damp) -> void:
	set_max_move_speed(mms)
	set_accel(accel)
	set_damping(damping)
	return

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	mms_neg = Vector2(-max_move_speed, -max_move_speed)
	mms_pos = Vector2(max_move_speed, max_move_speed)
	return

func _physics_process(delta: float) -> void:
	var damping_factor := (1.0/damping_rate) - 1
	var damp := Vector2(
		velocity.x * damping_factor, 
		velocity.y * damping_factor
	)
	
	velocity.x += damp.x + (accel_rate.x * delta)
	velocity.y += damp.y + (accel_rate.y * delta)
	velocity = velocity.clamp(mms_neg, mms_pos)
	move_and_slide()
	
	return

func set_accel(accel: Vector2) -> void:
	accel_rate = accel
	
func get_accel() -> Vector2:
	return accel_rate
	
func set_damping(damping: float) -> void:
	damping_rate = damping
	
func get_damping() -> float:
	return damping_rate
	
func set_max_move_speed(mms: float) -> void:
	max_move_speed = mms 

func get_max_move_speed() -> float:
	return max_move_speed
