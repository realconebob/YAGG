extends Zombie

func _ready() -> void:
	max_accel = 1200
	max_speed = 6000
	points = 15

func _physics_process(_delta: float) -> void:
	#var dir: Vector2 = ((target - position) as Vector2).normalized()
	#set_acc(dir * accel_rate)
	#super(delta)
	return
