class_name Zombie
extends BaseEntity

const def_point_val: int = 1

var target: Vector2:
	get: return target
	set(t): target = t
	
var points: int = def_point_val:
	get: return points
	set(np): points = max(1, np)

var accel_rate: float = 1500:
	get: return accel_rate
	set(na): accel_rate = max(0, na)

func _init() -> void:
	base_type = "Zombie"

func _ready() -> void:
	max_speed = 8000
	max_accel = 1200

func _physics_process(delta: float) -> void:
	var dir: Vector2 = ((target - position) as Vector2).normalized()
	set_acc(dir * accel_rate)
	super(delta)

## @deprecated: Implemented by Godot getter/setter syntax
func set_target(t: Vector2) -> void:
	target = t

## @deprecated: Implemented by Godot getter/setter syntax
func get_type() -> String:
	return "Zombie"

## @deprecated: Implemented by Godot getter/setter syntax
func get_point_value() -> int:
	return 1
