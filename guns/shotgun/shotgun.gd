extends BaseGun

const bullet_scene := preload("res://guns/shotgun/shotgun_bullet.tscn")

@onready var handle: Node2D = $Handle
@onready var barrel: Node2D = $BarrelEnd

func _ready() -> void:
	bullet_cooldown = 0.75

func make_bullets(t: Vector2, p: Vector2, o: Vector2) -> Array[BaseEntity]:
	var res: Array[BaseEntity] = []
	var pointing := (t - p).normalized()
	for i in range(9):
		var bullet: BaseEntity = bullet_scene.instantiate()
		var randrot: float = 0
		
		bullet.scale = Vector2.ONE * 0.5
		bullet.look_at(target)
		if i > 0:
			bullet.rotate(randrot)
			randrot = randf_range(-1, 1) * 1/16 * PI
		
		var theta := randrot + (pointing.angle() if !o else o.angle())
		
		bullet.max_speed = 5000
		bullet.accel = Vector2(cos(theta), sin(theta)) * 10000
		bullet.global_position = p
		res.append(bullet)
	
	return res

func get_handle() -> Node2D:
	return handle
	
func get_barrel() -> Node2D:
	return barrel
