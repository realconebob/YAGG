extends Zombie

func _ready() -> void:
	max_speed = 9000
	max_accel = 1200
	points = 151

func _physics_process(_delta: float) -> void:
	#var dir: Vector2 = ((target - position) as Vector2).normalized()
	#set_acc(dir * accel_rate)
	#super(delta)
	return
