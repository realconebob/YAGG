extends Zombie

func _init() -> void:
	super()

func _ready() -> void:
	max_speed = 9000
	max_accel = 1200
	points = 5

func _physics_process(_delta: float) -> void:
	#var dir: Vector2 = ((target - position) as Vector2).normalized()
	#set_acc(dir * accel_rate)
	#super(delta)
	return

## @deprecated: Implemented by Godot getter/setter syntax
func get_point_value() -> int:
	return 5
