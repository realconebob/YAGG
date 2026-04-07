extends Zombie

func _ready() -> void:
	set_max_acc(1200)
	set_max_speed(9000)

func _physics_process(_delta: float) -> void:
	#var dir: Vector2 = ((target - position) as Vector2).normalized()
	#set_acc(dir * accel_rate)
	#super(delta)
	return

func get_point_value() -> int:
	return 5
