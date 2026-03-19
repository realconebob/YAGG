class_name BasicZombie
extends BaseEntity

const bzomb_dmms: float = 600
const bzomb_dacc: Vector2 = Vector2.ZERO
const bzomb_dacr: float = bzomb_dmms * 2
const bzomb_ddmp: float = 1.1
const bzomb_slid: bool = false

@onready var target := Vector2.ZERO

func _init(mms: float = bzomb_dmms, accel: Vector2 = bzomb_dacc, accr: float = bzomb_dacr, damping: float = bzomb_ddmp) -> void:
	super(mms, accel, accr, damping, bzomb_slid)

func _physics_process(delta: float) -> void:
	# Mindlessly walk at the target
	var dir := (target - position).normalized()
	set_accel(dir * accel_rate)

	do_movement(delta)

func set_target(trgt: Vector2) -> void:
	target = trgt

func get_target() -> Vector2:
	return target
