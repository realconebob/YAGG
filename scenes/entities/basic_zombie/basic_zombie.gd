class_name BasicZombie
extends BaseEntity

const bzomb_dmms: float = 300
const bzomb_dacr: float = bzomb_dmms * 2
const bzomb_ddmp: float = 1.1

@onready var target := Vector2.ZERO

func _init() -> void:
	var movement_map: Dictionary[String, Variant] = {
		mms = bzomb_dmms,
		accr = bzomb_dacr,
		damp = bzomb_ddmp,
	}
	super(movement_map)

func _physics_process(delta: float) -> void:
	# Mindlessly walk at the target
	var dir := (target - position).normalized()
	set_accel(dir * accel_rate)
	do_movement(delta)
	return

func set_target(trgt: Vector2) -> void:
	target = trgt
func get_target() -> Vector2:
	return target

func get_type() -> String:
	return "BasicZombie"
