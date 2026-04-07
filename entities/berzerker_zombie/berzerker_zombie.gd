extends Zombie

func _init() -> void:
	super()

func _ready() -> void:
	max_accel = 1200
	max_speed = 6000
	points = 3

func _physics_process(_delta: float) -> void:
	#var dir: Vector2 = ((target - position) as Vector2).normalized()
	#set_acc(dir * accel_rate)
	#super(delta)
	return

## @deprecated: Implemented by Godot getter/setter syntax
func get_point_value() -> int:
	return 3
