extends BaseGun

const bullet_scene := preload("res://guns/shotgun/shotgun_bullet.tscn")

@onready var handle: Node2D = $Handle
@onready var barrel: Node2D = $BarrelEnd

func _ready() -> void:
	set_bullets_per_mag(6)
	set_reload_duration(6)
	set_bullet_cooldown(0.75)

func make_bullets(t: Vector2, p: Vector2) -> Array[BaseEntity]:
	var res: Array[BaseEntity] = []
	for i in range(9):
		var bullet: BaseEntity = bullet_scene.instantiate()
		var randrot: float = 0
		
		bullet.scale = Vector2.ONE * 0.5
		bullet.look_at(target)
		if i > 0:
			bullet.rotate(randrot)
			randrot = randf_range(-1, 1) * 1/16 * PI
		
		var theta := (t - p).normalized().angle() + randrot
		
		bullet.set_max_speed(5000)
		bullet.set_acc(Vector2(cos(theta), sin(theta)) * 10000)
		bullet.global_position = p
		res.append(bullet)
	
	return res

func get_handle() -> Node2D:
	return handle
	
func get_barrel() -> Node2D:
	return barrel
