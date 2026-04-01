extends BaseEntity

var target: Vector2
var accel_rate: float = 1500

func _ready() -> void:
	set_max_acc(1200)
	set_max_speed(8000)

func _physics_process(delta: float) -> void:
	var dir: Vector2 = ((target - position) as Vector2).normalized()
	set_acc(dir * accel_rate)
	super(delta)

func set_target(t: Vector2) -> void:
	target = t

func get_type() -> String:
	return "Zombie"
