class_name BaseEntity
extends CharacterBody2D

const default_mms := 1200
const default_accel := Vector2.ZERO
const default_accel_rate: float = default_mms * 5
const default_damp := 1.25

var max_move_speed: float = default_mms
var accel_rate: float = default_accel_rate
var damping_rate: float = default_damp

var _accel: Vector2 = default_accel

@onready var mms_neg: Vector2
@onready var mms_pos: Vector2

func _init(mms: float = default_mms, accel: Vector2 = default_accel, accr: float = default_accel_rate, damping: float = default_damp) -> void:
	set_max_move_speed(mms)
	set_accel(accel)
	set_accel_rate(accr)
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
	
	velocity.x += damp.x + (_accel.x * delta)
	velocity.y += damp.y + (_accel.y * delta)
	velocity = velocity.clamp(mms_neg, mms_pos)
	move_and_slide()
	
	return

func set_accel(accel: Vector2) -> void:
	_accel = accel
	
func get_accel() -> Vector2:
	return _accel
	
func set_accel_rate(accr: float) -> void:
	accel_rate = accr
	
func get_accel_rate() -> float:
	return accel_rate
	
func set_damping(damping: float) -> void:
	damping_rate = damping
	
func get_damping() -> float:
	return damping_rate
	
func set_max_move_speed(mms: float) -> void:
	max_move_speed = mms 
	if is_node_ready():
		mms_neg = Vector2(-max_move_speed, -max_move_speed)
		mms_pos = Vector2(max_move_speed, max_move_speed)

func get_max_move_speed() -> float:
	return max_move_speed
