extends BaseGun

const boolet := preload("res://scenes/guns/revolver/revolver_bullet.tscn")

func _ready() -> void:
	set_bullet_scene(boolet)

func create_bullets(t: Vector2, p: Vector2) -> Array[BaseEntity]:
	var res: Array[BaseEntity] = []
	var bullet: BaseEntity = boolet.instantiate()
	var mousepos := get_global_mouse_position()
	
	bullet.look_at(mousepos)
	bullet.set_max_speed(5000)
	bullet.set_acc((t - p).normalized() * 10000)
	bullet.global_position = p
	res.append(bullet)
	
	return res
	
func get_gun_sprite() -> AnimatedSprite2D:
	return $Sprites
	
func get_barrel() -> Node2D:
	return $BarrelEnd
	
func get_handle() -> Node2D:
	return $Handhold
