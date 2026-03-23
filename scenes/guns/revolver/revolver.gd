extends BaseGun

const boolet := preload("res://scenes/guns/revolver/revolver_bullet.tscn")

func _init() -> void:
	super(boolet)

func create_bullets() -> Array[BaseEntity]:
	var res: Array[BaseEntity] = []
	var bullet: BaseEntity = boolet.instantiate()
	var mousepos := get_global_mouse_position()
	
	# Set the bullet up
	bullet.look_at(mousepos)
	bullet.velocity = Vector2((mousepos - position).normalized() * bullet.get_accel_rate())
	
	res.append(bullet)
	return res
	
func get_gun_sprite() -> AnimatedSprite2D:
	return $Sprites
	
func get_barrel_end() -> Node2D:
	return $BarrelEnd
	
func get_hand_hold() -> Node2D:
	return $Handhold
